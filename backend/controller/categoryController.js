const Category = require("../model/categoryModel");

module.exports = {
  createCategory: async (req, res) => {
    const newCategory = new Category(req.body);
    try {
      await newCategory.save();
      res.status(200).json("Category Created");
    } catch (e) {
      res.status(500).json(e);
    }
  },
  getAllCategories: async (req, res) => {
    try {
      const category = await Category.find().sort({ createdAt: -1 });
      res.status(200).json(category);
    } catch (e) {
      res.status(500).json("Getting All Category Failed");
    }
  },
};
