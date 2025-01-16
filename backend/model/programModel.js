const mongoose = require("mongoose");
const sliceSchema = mongoose.Schema({
  sliceTitle: { type: String, require: false },
  sliceValue: { type: String, require: false },
});
const routineItems = mongoose.Schema({
  title: { type: String, require: false },
  description: { type: String, require: false },
  time: { type: String, require: false },
  isDone: { type: Boolean, require: false, default: "false" },
});
const programSchema = mongoose.Schema(
  {
    title: { type: String, require: false },
    description: { type: String, require: false },
    category: { type: String, require: false },
    sliceItems: [sliceSchema],
    author: { type: String, required: false },
    points: { type: [String], require: false },
    routineItems: [routineItems],
  },
  { timestamps: true }
);

module.exports = mongoose.model("program", programSchema);



