const mongoose = require("mongoose");
const userSchema = mongoose.Schema(
  {
    username: { type: String, required: true },
    program: { type: String, require: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model("user", userSchema);
