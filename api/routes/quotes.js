const express = require('express');
const xss = require('xss');

const router = express.Router();

router.get('/quotes', async (req, res) => {
    try {
        const rows = await req.dbConn.query("SELECT author,quote FROM quotes");
        res.json(rows);
    } catch (err) {
        if (req.dbConn) req.dbConn.release();
        req.dbConn = null;
        res.status(500).send({ message: err.message });
    }
});

router.get('/randomquote', async (req, res) => {
    try {
        const rows = await req.dbConn.query("SELECT author,quote FROM quotes");
        res.json(rows[Math.floor(Math.random() * rows.length)]);
    } catch (err) {
        if (req.dbConn) req.dbConn.release();
        req.dbConn = null;
        res.status(500).send({ message: err.message });
    }
});

router.post('/addquote', async (req, res) => {
    try {
        let { author, quote } = req.body;
        if (!author || !quote) {
            return res.status(400).send({ message: 'Author and quote are required.' });
        }
        // Sanitize the input
        author = xss(author);
        quote = xss(quote);

        const result = await req.dbConn.query("INSERT INTO quotes (author, quote) VALUES (?, ?)", [author, quote]);
        res.status(201).send({ message: 'Quote added successfully.' });
    } catch (err) {
        if (req.dbConn) req.dbConn.release();
        req.dbConn = null;
        res.status(500).send({ message: err.message });
    }
});

module.exports = router;
