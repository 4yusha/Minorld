const express = require('express');
const app = express();
const bcrypt = require("bcrypt");
const cors = require("cors");
const connection = require("./database"); 
const http = require('http');
const server = http.createServer(app); 
const nodemailer = require("nodemailer");
const otpGenerator = require("otp-generator");
const bodyParser = require("body-parser"); 
const jwt = require("jsonwebtoken");
const secretKey = require("secretkey");

app.use(bodyParser.json()); 
app.use(cors({ origin: '*' }));

app.post('/update_post', (req, res) => {
  const { postId, title, text } = req.body;

  try {
      // Check if required fields are provided
      if (!postId || !title || !text) {
          return res.status(400).send('Please provide postId, title, and text');
      }

      // Update the post in the database
      connection.query('UPDATE posts SET title = ?, text = ? WHERE postId = ?', [title, text, postId], (err, result) => {
          if (err) {
              console.error('Error executing database query:', err);
              res.status(500).send("An error occurred");
              return;
          }

          
          // Check if any rows were affected by the update
          if (result.affectedRows === 0) {
              return res.status(404).send("Post doesn't exist");
          }

          // Send success response
          res.status(200).send('Post updated successfully');
      });
  } catch (error) {
      console.error("An error occurred:", error);
      res.status(500).send("An error occurred");
  }
});




// Middleware to parse JSON bodies
app.post('/post', (req, res) => { 
  const { title, text } = req.body;
  console.log(title, text);

  // Perform any necessary validation
  if (!title || !text) {
    return res.status(400).json({ error: 'Title and body are required' });
  }

  // Insert the data into your database
  connection.query('INSERT INTO posts (title, text) VALUES (?, ?)', [title, text], (err, result) => {
    if (err) {
      console.error('Error inserting data into database:', err);
      return res.status(500).json({ error: 'Failed to insert data into database' });
    }
    
  });

  // For demonstration purposes, simply returning the received data
  return res.status(200).json({ title, text });
});


app.post('/signup', (req, res) => {
    const { name, email, createPassword, confirmPassword } = req.body;
    console.log(name, email, createPassword, confirmPassword);

    try {
        if (!name || !email || !createPassword || !confirmPassword) {
            res.status(400).send("Please fill all the fields");
            return;
        } else if (createPassword !== confirmPassword) {
            res.status(400).send("Password doesn't match");
            return;
        } else if (email.split("@").length === 1) {
            res.status(400).send('Please enter valid email');
            return;
        }

        // Hash the password before storing it in the database
        bcrypt.hash(createPassword, 10, function (err, hash) {
            if (err) {
                console.error('Error hashing password:', err);
                res.status(500).send("Error hashing password");
                return;
            }
            connection.query("INSERT INTO user_login (name, email, createPassword) VALUES(?,?,?)", [name, email, hash], function (err, data) {
                if (err) {
                    console.error('Error executing database query:', err);
                    res.status(500).send("Error executing database query");
                    return;
                }
                console.log("User Successfully Registered");
                res.status(200).send("User successfully registered");
            });
        });
    } catch (error) {
        console.error("An error occurred:", error);
        res.status(500).send("An error occurred");
    }
});

app.post('/sign', (req, res) => {
    const { email, createPassword } = req.body;
    console.log(email, createPassword);
  
    try {
      if (!email || !createPassword) {
        res.status(400).send('Please fill all the fields');
        return;
      }
  
      connection.query("SELECT * FROM user_login WHERE email=? LIMIT 1", [email], function (err, data) {
        if (err) {
          console.error('Error executing database query:', err);
          res.status(500).send("An error occurred");
          return;
        }
        if (data.length === 0) {
          res.status(404).send("User doesn't exist");
          return;
        }
        const user = data[0];
        // Compare hashed password
        bcrypt.compare(createPassword, user.createPassword, function (err, result) {
          if (err) {
            console.error('Error comparing passwords:', err);
            res.status(500).send("An error occurred");
            return;
          }
          if (result) {
            console.log("Log in Successful");
            res.send("Log in Successful");
          } else {
            console.log("Incorrect password");
            res.status(401).send("Incorrect password");
          }
        });
      });
    } catch (error) {
      console.error("An error occurred:", error);
      res.status(500).send("An error occurred");
    }
  });
  

app.post('/forgot_password', async (req, res) => {
    const { email } = req.body;

    try {
        if (!email) {
            return res.status(400).send('Please provide an email address');
        }

        // Check if the email exists in the database
        connection.query('SELECT * FROM user_login WHERE email = ?', [email], async function (err, users) {
            if (err) {
                console.error('Error executing database query:', err);
                res.status(500).send("An error occurred");
                return;
            }
            if (users.length === 0) {
                return res.status(404).send("User doesn't exist");
            }
            const user = users[0];

            // Generate OTP
            const otp = otpGenerator.generate(6, { digits: true });

            // Save the OTP in the database for this user 
            connection.query('UPDATE user_login SET reset_otp = ? WHERE email = ?', [otp, email], async function (err, result) {
                if (err) {
                    console.error('Error executing database query:', err);
                    res.status(500).send("An error occurred");
                    return;
                }
                // Send the OTP to the user via email
                const transporter = nodemailer.createTransport({
                    service: 'gmail',
                    auth: {
                        user: 'minorld024@gmail.com', // gmail
                        pass: 'iroa rojq juol xlfw' // gmail app password
                    }
                });
                const mailOptions = {
                    from: 'Minorld',
                    to: email,
                    subject: 'Password Reset OTP',
                    text: `Use this OTP to reset your password: ${otp}`
                };

                await transporter.sendMail(mailOptions);

                res.status(200).send('Password reset OTP has been sent to your email');
            });
        });
    } catch (error) {
        console.error("An error occurred:", error);
        res.status(500).send("An error occurred");
    }
});

app.post('/reset_password', async (req, res) => {
    const { email, reset_otp, newPassword, confirmPassword } = req.body;

    try {
        // Check if required fields are provided
        if (!email || !reset_otp || !newPassword || !confirmPassword) {
            return res.status(400).send('Please fill all the ');
        }

        // Check if passwords match
        if (newPassword !== confirmPassword) {
            return res.status(401).send("Passwords don't match");
        }

        // Check if the email exists in the database
        connection.query('SELECT * FROM user_login WHERE email = ?', [email], async function (err, users) {
            if (err) {
                console.error('Error executing database query:', err);
                res.status(500).send("An error occurred");
                return;
            }

            // Check if the user exists
            if (users.length === 0) {
                return res.status(404).send("User doesn't exist");
            }

            // Get the user from the query result
            const user = users[0];

            // Check if the provided OTP matches the one stored in the database
            if (reset_otp !== user.reset_otp) {
                return res.status(401).send("Invalid OTP");
            }

            // Generate a hash for the new password
            const hashedPassword = await bcrypt.hash(newPassword, 10);

            // Update the user's password and clear the reset OTP
            connection.query('UPDATE user_login SET createPassword = ?, reset_otp = NULL WHERE email = ?', [hashedPassword, email], async function (err, result) {
                if (err) {
                    console.error('Error executing database query:', err);
                    res.status(500).send("An error occurred");
                    return;
                }

                // Password successfully reset
                res.status(200).send('Password has been successfully reset');
            });
        });
    } catch (error) {
        console.error("An error occurred:", error);
        res.status(500).send("An error occurred");
    }
});

app.post('/update_profile', async (req, res) => {
  const { name, email, createPassword } = req.body;

  try {
      // Check if required fields are provided
      if (!name || !email || !createPassword) {
          return res.status(400).send('Please fill all the fields');
      }

      // Update the user's profile in the database
      connection.query(
          'UPDATE user_login SET name = ?, createPassword = ? WHERE email = ?',
          [name, createPassword, email],
          async function (err, result) {
              if (err) {
                  console.error('Error executing database query:', err);
                  return res.status(500).send("An error occurred");
              }

              // Check if any rows were affected by the update
              if (result.affectedRows === 0) {
                  return res.status(404).send("User doesn't exist");
              }

              // Redirect to the profile page upon successful update
              res.redirect('/profile'); // Assuming '/profile' is the route for the profile page
          }
      );
  } catch (error) {
      console.error("An error occurred:", error);
      res.status(500).send("An error occurred");
  }
});

server.listen(5000, () => {
    console.log('Listening to the port 5000');
});
