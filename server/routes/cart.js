const express = require('express')
const db = require('../db')
const router = express.Router()
const utils = require('../utils')

router.get('/:id', (request, response) => {
  const { id } = request.params
  db.query(
    `select c.id, c.productId, c.price, p.title, p.company, c.quantity, p.image  from cart c, product p where c.productId = p.id and c.userId = ?`,
    [id],
    (error, items) => {
      response.send(utils.createResult(error, items))
    }
  )
})

router.post('/:id', (request, response) => {
  const { id } = request.params
  const { productId, price, quantity } = request.body

  // make sure that the product is not already added earlier
  db.query(
    `select * from cart where userId = ? and productId = ?`,
    [id, productId],
    (error, items) => {
      if (items.length == 0) {
        // this product does not exist in the cart
        // insert the product in the cart
        db.query(
          `insert into cart (userId, productId, quantity, price) values (?, ?, ?, ?)`,
          [id, productId, quantity, price],
          (error, result) => {
            response.send(utils.createResult(error, result))
          }
        )
      } else {
        // this product is already added in the cart
        // update the product quantity
        const oldQuantity = items[0].quantity
        db.query(
          `update cart set quantity = ? where userId = ? and productId = ?`,
          [oldQuantity + quantity, id, productId],
          (error, result) => {
            response.send(utils.createResult(error, result))
          }
        )
      }
    }
  )
})

router.put('/quantity/:id', (request, response) => {
  const { id } = request.params
  const { quantity } = request.body
  db.query(
    `update cart set quantity = ? where id = ? `,
    [quantity, id],
    (error, result) => {
      response.send(utils.createResult(error, result))
    }
  )
})

router.delete('/:id', (request, response) => {
  const { id } = request.params
  db.query(`delete from cart where id = ? `, [id], (error, result) => {
    response.send(utils.createResult(error, result))
  })
})

module.exports = router
