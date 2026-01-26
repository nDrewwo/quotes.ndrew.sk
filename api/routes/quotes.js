const express = require('express');
const xss = require('xss');
const fetch = require('node-fetch');

const router = express.Router();

// Fetch feature toggles from the API
async function getFeatureToggles() {
    try {
        const response = await fetch('https://api.ndrew.sk/feature-toggles');
        const toggles = await response.json();
        const toggleMap = {};
        toggles.forEach(toggle => {
            toggleMap[toggle.name] = toggle.value;
        });
        return toggleMap;
    } catch (err) {
        console.error('Error fetching feature toggles:', err.message);
        // Return empty object on failure, allowing all quotes
        return {};
    }
}

router.get('/quotes', async (req, res) => {
    try {
        const toggles = await getFeatureToggles();
        const nsfwEnabled = toggles.nsfwQuotes === 1;
        
        let query = "SELECT author,quote FROM quotes";
        if (!nsfwEnabled) {
            query += " WHERE nsfw = 0";
        }
        
        const rows = await req.dbConn.query(query);
        res.json(rows);
    } catch (err) {
        if (req.dbConn) req.dbConn.release();
        req.dbConn = null;
        res.status(500).send({ message: err.message });
    }
});

router.get('/randomquote', async (req, res) => {
    try {
        const toggles = await getFeatureToggles();
        const nsfwEnabled = toggles.nsfwQuotes === 1;
        
        let query = "SELECT author,quote FROM quotes";
        if (!nsfwEnabled) {
            query += " WHERE nsfw = 0";
        }
        
        const rows = await req.dbConn.query(query);
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
