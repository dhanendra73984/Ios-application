const express = require('express')
const cryptoJs = require('crypto-js')
const multer = require('multer')
const upload = multer({ dest: 'uploads' })
const mailer = require('../mailer')

const db = require('../db')
const utils = require('../utils')

const router = express.Router()

router.put('/change-password/:userId', (request, response) => {
  const { userId } = request.params
  const { password } = request.body
  const encryptedPassword = String(cryptoJs.SHA256(password))
  db.query(
    `update user set password = ? where id = ?`,
    [encryptedPassword, userId],
    (error, result) => {
      response.send(utils.createResult(error, result))
    }
  )
})

router.post(
  '/upload-profile-image/:userId',
  upload.single('image'),
  (request, response) => {
    const { userId } = request.params
    const filename = request.file.filename
    db.query(
      `update user set profileImage = ? where id = ?`,
      [filename, userId],
      (error, result) => {
        response.send(utils.createResult(error, result))
      }
    )
  }
)

router.post('/register', (request, response) => {
  const { firstName, lastName, email, mobile, password } = request.body

  // encrypt the password
  const encryptedPassword = String(cryptoJs.SHA256(password))

  db.query(
    'INSERT INTO user(firstName, lastName, email, mobile, password) VALUES(?, ?, ?, ?, ?)',
    [firstName, lastName, email, mobile, encryptedPassword],
    (error, result) => {
      // send a welcome email to the user
      mailer.sendEmail(
        email,
        'welcome to MyStore',
        `
        <html>
          <body>
            <h1>MyStore</h1>
            <p>Dear ${firstName}, </p>
            <br/>
            <br/>
            <p>Welcome to MyStore. You will find best products on the website.. blah blah blah..</p>

            <br/>
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

router.post('/login', (request, response) => {
  const { email, password } = request.body

  // encrypt the password
  const encryptedPassword = String(cryptoJs.SHA256(password))

  const statement = 'SELECT * FROM user WHERE email=? and password=?'
  db.query(statement, [email, encryptedPassword], (error, users) => {
    if (users.length == 0) {
      // if user does not exist, users array will be empty
      response.send(utils.createResult('user does not exist'))
    } else {
      // if user exists, the users will be an array with one user entry
      const user = users[0]
      response.send(
        utils.createResult(null, {
          name: `${user['firstName']} ${user['lastName']}`,
          mobile: user['mobile'],
          id: user['id'],
          profileImage: user['profileImage'],
        })
      )
    }
  })
})

router.get('/:id', (request, response) => {
  const id = request.params.id
  const statement = `SELECT * FROM user WHERE id=?`
  db.query(statement, [id], (error, users) => {
    if (users.length == 0) {
      response.send(utils.createResult('user does not exist'))
    } else {
      const user = users[0]
      response.send(
        utils.createResult(null, {
          name: `${user['firstName']} ${user['lastName']}`,
          mobile: user['mobile'],
          email: user['email'],
          id: user['id'],
          profileImage: user['profileImage'],
        })
      )
    }
  })
})

module.exports = router
