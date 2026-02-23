class Exercise {
  final String name;
  final String type; // "reps" or "time"
  final int value; // 20 seconds or 10 reps
  final String animationAsset;

  Exercise({
    required this.name,
    required this.type,
    required this.value,
    required this.animationAsset,
  });
}

class WorkoutDay {
  final String title; // Day 1
  final List<Exercise> exercises;

  WorkoutDay({
    required this.title,
    required this.exercises,
  });
}

class WorkoutPlanGenerator {
  /// Generates a personalized workout plan based on user metrics.
  List<WorkoutDay> generatePlan({
    required String goal,
    required String activityLevel,
    required int weeklyDays,
    String focus = "Full Body",
  }) {
    List<WorkoutDay> plan = [];

    // Difficulty Multiplier based on Activity Level
    double multiplier = 1.0;
    switch (activityLevel.toLowerCase()) {
      case "sedentary": multiplier = 0.7; break;
      case "lightly active": multiplier = 1.0; break;
      case "moderately active": multiplier = 1.3; break;
      case "very active": multiplier = 1.6; break;
      default: multiplier = 1.0;
    }

    for (int i = 1; i <= weeklyDays; i++) {
      List<Exercise> exercises = [];

      // Logic for Muscle Growth
      if (goal == "Muscle Growth") {
        if (focus == "Upper Body") {
          exercises = [
            Exercise(
              name: "Diamond Push-Ups",
              type: "reps",
              value: (10 * multiplier).toInt(),
              animationAsset: "https://lottie.host/802613b4-539c-4874-94e0-94a1d48c8b8b/2sB7ySNozN.json",
            ),
            Exercise(
              name: "Wide Push-Ups",
              type: "reps",
              value: (12 * multiplier).toInt(),
              animationAsset: "https://lottie.host/7e0c4e12-0e24-4f4a-9b4e-e44e2b800e8b/8U5S2O1W3X.json",
            ),
            Exercise(
              name: "Arm Circles",
              type: "time",
              value: (40 * multiplier).toInt(),
              animationAsset: "https://lottie.host/6f0219c4-1a3b-4861-bb38-0c65345638c0/3uT0x7H8YV.json",
            ),
          ];
        } else if (focus == "Lower Body") {
          exercises = [
            Exercise(
              name: "Jumping Squats",
              type: "reps",
              value: (15 * multiplier).toInt(),
              animationAsset: "https://lottie.host/802613b4-539c-4874-94e0-94a1d48c8b8b/2sB7ySNozN.json",
            ),
            Exercise(
              name: "Lunges",
              type: "reps",
              value: (12 * multiplier).toInt(),
              animationAsset: "https://lottie.host/802613b4-539c-4874-94e0-94a1d48c8b8b/2sB7ySNozN.json",
            ),
            Exercise(
              name: "Glute Bridges",
              type: "reps",
              value: (20 * multiplier).toInt(),
              animationAsset: "https://lottie.host/802613b4-539c-4874-94e0-94a1d48c8b8b/2sB7ySNozN.json",
            ),
          ];
        } else if (focus == "Core & Abs") {
          exercises = [
            Exercise(
              name: "Plank",
              type: "time",
              value: (45 * multiplier).toInt(),
              animationAsset: "https://lottie.host/bd23bc42-990a-472e-8418-500e84b84b8b/F8S2O1W3X.json",
            ),
            Exercise(
              name: "Mountain Climbers",
              type: "time",
              value: (40 * multiplier).toInt(),
              animationAsset: "https://lottie.host/bd23bc42-990a-472e-8418-500e84b84b8b/F8S2O1W3X.json",
            ),
            Exercise(
              name: "Leg Raises",
              type: "reps",
              value: (15 * multiplier).toInt(),
              animationAsset: "https://lottie.host/bd23bc42-990a-472e-8418-500e84b84b8b/F8S2O1W3X.json",
            ),
          ];
        } else {
          // Full Body Muscle Growth
          exercises = [
            Exercise(
              name: "Push-Ups",
              type: "reps",
              value: (15 * multiplier).toInt(),
              animationAsset: "https://lottie.host/7e0c4e12-0e24-4f4a-9b4e-e44e2b800e8b/8U5S2O1W3X.json",
            ),
            Exercise(
              name: "Squats",
              type: "reps",
              value: (20 * multiplier).toInt(),
              animationAsset: "https://lottie.host/802613b4-539c-4874-94e0-94a1d48c8b8b/2sB7ySNozN.json",
            ),
            Exercise(
              name: "Burpees",
              type: "reps",
              value: (10 * multiplier).toInt(),
              animationAsset: "https://lottie.host/7e0c4e12-0e24-4f4a-9b4e-e44e2b800e8b/8U5S2O1W3X.json",
            ),
          ];
        }
      } 
      // Logic for Weight Loss (High Cardio)
      else if (goal == "Weight Loss") {
        exercises = [
          Exercise(
            name: "Jumping Jacks",
            type: "time",
            value: (60 * multiplier).toInt(),
            animationAsset: "https://lottie.host/6f0219c4-1a3b-4861-bb38-0c65345638c0/3uT0x7H8YV.json",
          ),
          Exercise(
            name: "High Knees",
            type: "time",
            value: (45 * multiplier).toInt(),
            animationAsset: "https://lottie.host/6f0219c4-1a3b-4861-bb38-0c65345638c0/3uT0x7H8YV.json",
          ),
          Exercise(
            name: "Mountain Climbers",
            type: "time",
            value: (50 * multiplier).toInt(),
            animationAsset: "https://lottie.host/bd23bc42-990a-472e-8418-500e84b84b8b/F8S2O1W3X.json",
          ),
          Exercise(
            name: "Burpees",
            type: "reps",
            value: (12 * multiplier).toInt(),
            animationAsset: "https://lottie.host/7e0c4e12-0e24-4f4a-9b4e-e44e2b800e8b/8U5S2O1W3X.json",
          ),
        ];
      }
      // Logic for Better Health (Stamina/Energy)
      else {
        exercises = [
          Exercise(
            name: "Brisk Walking on Spot",
            type: "time",
            value: (90 * multiplier).toInt(),
            animationAsset: "https://lottie.host/6f0219c4-1a3b-4861-bb38-0c65345638c0/3uT0x7H8YV.json",
          ),
          Exercise(
            name: "Gentle Squats",
            type: "reps",
            value: (12 * multiplier).toInt(),
            animationAsset: "https://lottie.host/802613b4-539c-4874-94e0-94a1d48c8b8b/2sB7ySNozN.json",
          ),
          Exercise(
            name: "Knee Push-Ups",
            type: "reps",
            value: (8 * multiplier).toInt(),
            animationAsset: "https://lottie.host/9e48753e-5f8a-4d43-8f0a-156372d8e4f5/H6O5S8Y1A1.json",
          ),
          Exercise(
            name: "Standing Side Reach",
            type: "time",
            value: (30 * multiplier).toInt(),
            animationAsset: "https://lottie.host/6f0219c4-1a3b-4861-bb38-0c65345638c0/3uT0x7H8YV.json",
          ),
        ];
      }

      // Add variety for later days (rotate or shuffle)
      if (i > 1) {
        exercises = exercises.reversed.toList();
      }

      plan.add(WorkoutDay(
        title: "Day $i",
        exercises: exercises,
      ));
    }

    return plan;
  }
}
