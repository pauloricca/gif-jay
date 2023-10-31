var express = require('express');
var router = express.Router();
const gifSearch = require('../api/gifSearch');
const gifSave = require('../api/gifSave');

router.get('/gifsearch/:query/', gifSearch);
router.post('/save/:name', gifSave);

module.exports = router;
