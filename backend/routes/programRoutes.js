const router = require("express").Router();
const programController = require("../controller/programController");

router.get("/", programController.getAllProgram);
router.get("/:id", programController.getProgram);
router.post("/", programController.createProgram);
router.get("/routines/:id", programController.showAllRoutineItems);
router.post("/toggle/:id", programController.toggleProgram);
router.post("/category", programController.getProgramByCategory);
module.exports = router;
