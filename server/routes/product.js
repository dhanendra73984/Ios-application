const express = require('express')
const db = require('../db')
const router = express.Router()
const utils = require('../utils')

// for uploading file(s)
const multer = require('multer')
const upload = multer({ dest: 'uploads' })

// image in the single method is the key client has to use
// when uploading a file
router.post('/', upload.single('image'), (request, response) => {
  const { title, description, price, company } = request.body

  // request has a property named file which gives details of uploaded file
  // console.log(request.file)
  const filename = request.file.filename

  db.query(
    `insert into product (title, description, price, company, image) values (?, ?, ?, ?, ?)`,
    [title, description, price, company, filename],
    (error, result) => {
      response.send(utils.createResult(error, result))
    }
  )
})

router.get('/', (request, response) => {
  const statement = `SELECT id, title, price, company, image FROM product`
  db.query(statement, (error, result) => {
    response.send(utils.createResult(error, result))
  })
})

router.get('/:id', (request, response) => {
  const id = request.params.id
  const statement = `SELECT * FROM product WHERE id=?`
  db.query(statement, [id], (error, products) => {
    if (products.length == 0) {
      response.send(utils.createResult('no products'))
    } else {
      response.send(utils.createResult(error, products[0]))
    }
  })
})

module.exports = router
