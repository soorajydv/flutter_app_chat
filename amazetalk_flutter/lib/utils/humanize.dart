String humanizeDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  // If the difference is less than 1 minute
  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} second${difference.inSeconds == 1 ? '' : 's'} ago';
  }

  // If the difference is less than 1 hour
  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  }

  // If the difference is less than 1 day
  if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  }

  // If the difference is less than 1 week
  if (difference.inDays < 7) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  }

  // If the difference is less than 1 month (approx 30 days)
  if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks week${weeks == 1 ? '' : 's'} ago';
  }

  // If the difference is more than a month
  final months = (difference.inDays / 30).floor();
  if (months < 12) {
    return '$months month${months == 1 ? '' : 's'} ago';
  }

  // If the difference is more than a year
  final years = (difference.inDays / 365).floor();
  return '$years year${years == 1 ? '' : 's'} ago';
}
