const router = require("express").Router();
const userController = require("../controller/userController");

router.post("/", userController.createUser);
router.get("/", userController.getAllUsers);
router.get("/:id", userController.getUserById);
router.post('/username', userController.getUserByUsername);
router.put("/:id", userController.updateUser);
router.delete("/:id", userController.deleteUser);
module.exports = router;
