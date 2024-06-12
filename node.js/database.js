const sql = require('mysql');
const connection = sql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'minorld',  
});

connection.connect((err) => {
    if (err){
        console.error('Database connection fail', err);
    }
    else{
        console.log('Successfully connected to database! ');
    }
});

module.exports = connection;