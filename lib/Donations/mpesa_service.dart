// services/mpesa_service.dart
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

class MpesaService {
  Future<void> initializeMpesaPlugin({
    required String consumerKey,
    required String consumerSecret,
  }) async {
    try {
      await MpesaFlutterPlugin.setConsumerKey(consumerKey);
      await MpesaFlutterPlugin.setConsumerSecret(consumerSecret);
      print('Mpesa Flutter Plugin initialized successfully!');
    } catch (error) {
      print('Mpesa Flutter Plugin initialization error: $error');
      // Handle initialization errors appropriately
    }
  }

// Other Mpesa-related functions (startTransaction, handleCallbacks, etc.)
}