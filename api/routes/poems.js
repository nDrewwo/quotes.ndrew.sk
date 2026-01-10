const express = require('express');

const router = express.Router();

router.get('/poems', async (req, res) => {
    try {
        const rows = await req.dbConn.query("SELECT author,poem FROM poems");

        // Replace new line characters with <br/> for HTML, do NOT escape quotes manually
        const formattedRows = rows.map(row => ({
            ...row,
            poem: row.poem.replace(/\r\n|\n|\r/g, '<br/>') // Handle newlines for HTML
        }));

        res.json(formattedRows); // res.json handles correct JSON serialization
    } catch (err) {
        if (req.dbConn) req.dbConn.release();
        req.dbConn = null;
        res.status(500).send({ message: err.message });
    }
});

router.get('/randompoem', async (req, res) => {
    try {
        const rows = await req.dbConn.query("SELECT author,poem FROM poems");

        // Select a random poem and format it similarly by replacing newlines with <br/>
        const randomPoem = rows[Math.floor(Math.random() * rows.length)];
        const formattedPoem = {
            ...randomPoem,
            poem: randomPoem.poem.replace(/\r\n|\n|\r/g, '<br/>') // Handle newlines for HTML
        };

        res.json(formattedPoem);
    } catch (err) {
        if (req.dbConn) req.dbConn.release();
        req.dbConn = null;
        res.status(500).send({ message: err.message });
    }
});

module.exports = router;
