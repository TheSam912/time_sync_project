const User = require("../model/userModel");

module.exports = {
  createUser: async (req, res) => {
    const newUser = new User(req.body);
    try {
      await newUser.save();
      res.status(200).json(newUser);
    } catch (error) {
      res.status(500).json({ message: "Failed to create user" });
    }
  },
  getAllUsers: async (req, res) => {
    try {
      const users = await User.find();
      res.status(200).json(users);
    } catch (error) {
      res.status(500).json({ message: "Failed to get all users" });
    }
  },
  getUserById: async (req, res) => {
    try {
      const id = req.params.id;
      const user = await User.findById(id);
      if (!user) {
        res.status(404).json({ message: "User not found" });
      } else {
        res.status(200).json(user);
      }
    } catch (error) {
      res.status(500).json({ message: "Failed to get user by id" });
    }
  },

  getUserByUsername: async (req, res) => {
    try {
      const username = req.body.username;
      const user = await User.findOne({ username: username });
      if (!user) {
        res.status(404).json({ message: "User not found" });
      } else {
        res.status(200).json(user);
      }
    } catch (error) {
      res.status(500).json({ message: "Failed to get user by username" });
    }
  },

  updateUser: async (req, res) => {
    try {
      const id = req.params.id;
      const updatedUser = await User.findByIdAndUpdate(id, req.body, {
        new: true,
      });
      if (!updatedUser) {
        res.status(404).json({ message: "User not found" });
      } else {
        res.status(200).json(updatedUser);
      }
    } catch (error) {
      res.status(500).json({ message: "Failed to update user" });
    }
  },
  deleteUser: async (req, res) => {
    try {
      const id = req.params.id;
      await User.findByIdAndDelete(id);
      res.status(200).json({ message: "User deleted successfully" });
    } catch (error) {
      res.status(500).json({ message: "Failed to delete user" });
    }
  },
};
