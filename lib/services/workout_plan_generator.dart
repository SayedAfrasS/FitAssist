class Exercise {
  final String name;
  final String type; // "reps" or "time"
  final int value; // 20 seconds or 10 reps
  final String animationAsset;
  final String? target; // "chest", "back", "abs", etc.

  Exercise({
    required this.name,
    required this.type,
    required this.value,
    required this.animationAsset,
    this.target,
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
  static const String lottiePushUps = "https://lottie.host/7e0c4e12-0e24-4f4a-9b4e-e44e2b800e8b/8U5S2O1W3X.json";
  static const String lottieSquats = "https://lottie.host/802613b4-539c-4874-94e0-94a1d48c8b8b/2sB7ySNozN.json";
  static const String lottieCardio = "https://lottie.host/6f0219c4-1a3b-4861-bb38-0c65345638c0/3uT0x7H8YV.json";
  static const String lottieAbs = "https://lottie.host/bd23bc42-990a-472e-8418-500e84b84b8b/F8S2O1W3X.json";

  final Map<String, List<Map<String, dynamic>>> _exerciseLibrary = {
    'Chest': [
      {'name': 'Diamond Push-Ups', 'type': 'reps', 'baseValue': 10, 'asset': lottiePushUps},
      {'name': 'Wide Push-Ups', 'type': 'reps', 'baseValue': 12, 'asset': lottiePushUps},
      {'name': 'Standard Push-Ups', 'type': 'reps', 'baseValue': 15, 'asset': lottiePushUps},
      {'name': 'Incline Push-Ups', 'type': 'reps', 'baseValue': 12, 'asset': lottiePushUps},
    ],
    'Upper Body': [
      {'name': 'Arm Circles', 'type': 'time', 'baseValue': 40, 'asset': lottieCardio},
      {'name': 'Pike Push-Ups', 'type': 'reps', 'baseValue': 8, 'asset': lottiePushUps},
      {'name': 'Dips', 'type': 'reps', 'baseValue': 10, 'asset': lottiePushUps},
      {'name': 'Shadow Boxing', 'type': 'time', 'baseValue': 60, 'asset': lottieCardio},
    ],
    'Lower Body': [
      {'name': 'Squats', 'type': 'reps', 'baseValue': 20, 'asset': lottieSquats},
      {'name': 'Jumping Squats', 'type': 'reps', 'baseValue': 15, 'asset': lottieSquats},
      {'name': 'Lunges', 'type': 'reps', 'baseValue': 12, 'asset': lottieSquats},
      {'name': 'Glute Bridges', 'type': 'reps', 'baseValue': 20, 'asset': lottieSquats},
      {'name': 'Wall Sit', 'type': 'time', 'baseValue': 30, 'asset': lottieSquats},
    ],
    'Core & Abs': [
      {'name': 'Plank', 'type': 'time', 'baseValue': 45, 'asset': lottieAbs},
      {'name': 'Mountain Climbers', 'type': 'time', 'baseValue': 40, 'asset': lottieAbs},
      {'name': 'Leg Raises', 'type': 'reps', 'baseValue': 15, 'asset': lottieAbs},
      {'name': 'Crunches', 'type': 'reps', 'baseValue': 20, 'asset': lottieAbs},
      {'name': 'Bicycle Crunches', 'type': 'reps', 'baseValue': 20, 'asset': lottieAbs},
    ],
    'Full Body': [
      {'name': 'Burpees', 'type': 'reps', 'baseValue': 10, 'asset': lottiePushUps},
      {'name': 'Jumping Jacks', 'type': 'time', 'baseValue': 45, 'asset': lottieCardio},
      {'name': 'High Knees', 'type': 'time', 'baseValue': 40, 'asset': lottieCardio},
      {'name': 'Bear Crawls', 'type': 'time', 'baseValue': 30, 'asset': lottiePushUps},
    ],
    'Cardio': [
      {'name': 'Running in Place', 'type': 'time', 'baseValue': 60, 'asset': lottieCardio},
      {'name': 'Butt Kicks', 'type': 'time', 'baseValue': 45, 'asset': lottieCardio},
      {'name': 'Side Shuffles', 'type': 'time', 'baseValue': 30, 'asset': lottieCardio},
    ]
  };

  List<WorkoutDay> generatePlan({
    required String goal,
    required String activityLevel,
    required int weeklyDays,
    String focus = "Full Body",
    String mood = "Neutral",
  }) {
    List<WorkoutDay> plan = [];

    // Base Multiplier from Activity Level
    double levelMult = 1.0;
    switch (activityLevel.toLowerCase()) {
      case "sedentary": levelMult = 0.7; break;
      case "lightly active": levelMult = 1.0; break;
      case "moderately active": levelMult = 1.3; break;
      case "very active": levelMult = 1.6; break;
    }

    // Mood Multiplier
    double moodMult = 1.0;
    switch (mood.toLowerCase()) {
      case "energetic": moodMult = 1.25; break;
      case "tired": moodMult = 0.7; break;
      case "focused": moodMult = 1.1; break;
      case "stressed": moodMult = 0.85; break;
    }

    final totalMultiplier = levelMult * moodMult;

    for (int i = 1; i <= weeklyDays; i++) {
      List<Exercise> exercises = [];
      
      // Determine primary and secondary categories for the plan
      List<String> categories = [];
      if (focus == "Full Body") {
        categories = ['Full Body', 'Lower Body', 'Upper Body', 'Core & Abs'];
      } else if (focus == "Upper Body") {
        categories = ['Upper Body', 'Chest', 'Full Body'];
      } else if (focus == "Lower Body") {
        categories = ['Lower Body', 'Full Body'];
      } else if (focus == "Core & Abs") {
        categories = ['Core & Abs', 'Full Body'];
      } else if (focus == "Chest") {
        categories = ['Chest', 'Upper Body', 'Full Body'];
      } else {
        categories = [focus, 'Full Body', 'Core & Abs'];
      }

      // Add a flavor of goal-specific exercises
      if (goal == "Weight Loss") {
        categories.insert(0, 'Cardio');
      }

      // Pick exercises from these categories
      int exerciseCount = (mood == "Tired" ? 4 : 6);
      
      for (var cat in categories) {
        if (_exerciseLibrary.containsKey(cat)) {
          final catExercises = _exerciseLibrary[cat]!;
          // Add 1 or 2 exercises from this category
          int toAdd = (exercises.length < exerciseCount) ? 2 : 0;
          
          List<Map<String, dynamic>> shuffled = List.from(catExercises)..shuffle();
          for (int j = 0; j < toAdd && j < shuffled.length; j++) {
            final exData = shuffled[j];
            
            // Adjust value based on goal
            int baseValue = exData['baseValue'];
            if (goal == "Muscle Growth" && exData['type'] == 'reps') {
              baseValue = (baseValue * 1.2).toInt();
            } else if (goal == "Better Health") {
              baseValue = (baseValue * 0.9).toInt();
            }

            exercises.add(Exercise(
              name: exData['name'],
              type: exData['type'],
              value: (baseValue * totalMultiplier).toInt(),
              animationAsset: exData['asset'],
              target: cat.toLowerCase(),
            ));
          }
        }
        if (exercises.length >= exerciseCount) break;
      }

      // Shuffle for daily variety
      exercises.shuffle();

      plan.add(WorkoutDay(
        title: "Day $i",
        exercises: exercises,
      ));
    }

    return plan;
  }
}
