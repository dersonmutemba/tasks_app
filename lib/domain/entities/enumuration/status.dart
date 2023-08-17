enum Status {
  doing,
  aborted,
  completed,
  paused,
  notStarted,
  unknown,
}

Status? statusFromString(String text) {
  text = text.split('.').last;
  for(Status status in Status.values) {
    if(status.name.toLowerCase() == text.toLowerCase()) {
      return status;
    }
  }
  return null;
}