const Program = require("../model/programModel");

module.exports = {
  createProgram: async (req, res) => {
    const newProgram = new Program(req.body);
    try {
      await newProgram.save();
      res.status(200).json(newProgram);
    } catch (error) {
      res.status(500).json(error);
    }
  },
  getAllProgram: async (req, res) => {
    try {
      const program = await Program.find().sort({ createdAt: -1 });
      res.status(200).json(program);
    } catch (error) {
      res.status(500).json(error);
    }
  },
  getProgram: async (req, res) => {
    try {
      const program = await Program.findById(req.params.id);
      const { __v, createdAt, ...programData } = program._doc;
      res.status(200).json(programData);
    } catch (error) {
      res.status(500).json("Program Not Found!");
    }
  },
  getProgramByCategory: async (req, res) => {
    try {
      const category = req.body.category;
      const programs = await Program.find({ category: category });
      res.status(200).json(programs);
    } catch (error) {
      res.status(500).json(error);
    }
  },
  showAllRoutineItems: async (req, res) => {
    try {
      const program = await Program.findById(req.params.id);
      if (!program) {
        return res.status(404).json({ message: "Failed To Find The Program" });
      }
      const routineItems = await program.routineItems;
      res.status(200).json(routineItems);
    } catch {
      res.status(500).json(error);
    }
  },
  toggleProgram: async (req, res) => {
    const routineId = req.body._id;
    try {
      const program = await Program.findById(req.params.id);
      if (!program) {
        return res.status(404).json({ message: "Failed To Find The Program" });
      }
      const routineItem = program.routineItems.find((item) =>
        item._id.equals(routineId)
      );
      if (!routineItem) {
        return res
          .status(404)
          .json({ message: "Failed To Find The Routine Item" });
      }
      routineItem.isDone = !routineItem.isDone;
      await program.save();
      res.status(200).json(routineItem);
    } catch (error) {
      console.log(error);
      res.status(500).json(error);
    }
  },
};
