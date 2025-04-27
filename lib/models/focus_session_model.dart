class FocusSession {
  final String id;
  final DateTime startTime;
  DateTime? endTime;
  final Duration? duration;
  final bool isCompleted;

  FocusSession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.duration,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration?.inSeconds,
      'isCompleted': isCompleted,
    };
  }

  factory FocusSession.fromMap(Map<String, dynamic> map) {
    return FocusSession(
      id: map['id'],
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      duration: map['duration'] != null ? Duration(seconds: map['duration']) : null,
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
