var express = require('express');
var router = express.Router();
const gifSearch = require('../api/gifSearch');
const { getGalleries, getGallery, playGallery } = require('../api/galleries');
const { setSetting } = require('../api/settings');
const gifSave = require('../api/gifSave');

router.get('/galleries/', getGalleries);
router.get('/galleries/:gallery', getGallery);
router.get('/galleries/:gallery/play', playGallery);
router.get('/gifsearch/:query/', gifSearch);
router.post('/save/:name', gifSave);
router.get('/setting/:setting/:value', setSetting);

module.exports = router;
