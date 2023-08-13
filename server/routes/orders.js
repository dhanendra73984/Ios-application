const express = require('express')
const db = require('../db')
const router = express.Router()
const utils = require('../utils')
const mailer = require('../mailer')

router.get('/:userId', (request, response) => {
  const { userId } = request.params
  db.query(
    'select * from userOrder where userId = ?',
    [userId],
    (error, result) => {
      response.send(utils.createResult(error, result))
    }
  )
})

router.post('/:userId', (request, response) => {
  const { userId } = request.params
  const { totalPrice, email } = request.body

  // step 1: get all the cart items for the user
  db.query(`select * from cart where userId = ?`, [userId], (error, items) => {
    if (items.length == 0) {
      response.send(utils.createResult('not items'))
    } else {
      // step 2: create an order in userOder table and get the orderId
      db.query(
        `insert into userOrder (userId, totalPrice) values (?, ?)`,
        [userId, totalPrice],
        (error, order) => {
          if (!order) {
            response.send(utils.createResult('cannot create order'))
          } else {
            // get the newly inserted record id
            // and use it as orderId of orderDetails table
            const orderId = order.insertId

            // step 3: add all the product details against the orderId
            const query = `insert into orderDetails (orderId, productId, price, quantity) values `
            let subQuery = ``
            for (const item of items) {
              // add a comma after every row details
              if (subQuery.length > 0) {
                subQuery += `,`
              }

              // add the cart (product) details in the order
              subQuery += ` (${orderId}, ${item['productId']}, ${item['price']}, ${item['quantity']}) `
            }
            console.log(`${query}${subQuery}`)

            // attach main query and subQuery
            const finalQuery = query + subQuery
            db.query(finalQuery, (error, result) => {
              // step 4: remove all the items from the cart table
              db.query(
                'delete from cart where userId = ?',
                [userId],
                (error, result) => {
                  mailer.sendEmail(
                    email,
                    'Congratulation!! You have placed a new order.',
                    `
                  <html>
                  <body>
                    <h1>Order confirmed!!</h1>
                    <h3>With this email we are confirming your order placed on ${new Date()} with order id ${orderId}. </h3>
                    <h3>Please be ready with Rs. ${totalPrice}</h3>
                    <br/>

                    <p>Thank you.</p>
                  </body>
                  </html>
                  `,
                    () => {
                      response.send(utils.createResult(error, result))
                    }
                  )
                }
              )
            })
          }
        }
      )
    }
  })
})

router.get('/:id', (request, response) => {
  const id = request.params.id
  const statement = `SELECT m.* FROM mobiles m INNER JOIN orders o on m.id=o.mid WHERE o.uid=?`
  db.query(statement, [id], (error, result) => {
    response.send(utils.createResult(error, result))
  })
})

module.exports = router
