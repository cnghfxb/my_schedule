import 'package:amplify_flutter/amplify_flutter.dart';

void handleUpdateUserAttributeResult(
  UpdateUserAttributeResult result,
) {
  switch (result.nextStep.updateAttributeStep) {
    case AuthUpdateAttributeStep.confirmAttributeWithCode:
      final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
      _handleCodeDelivery(codeDeliveryDetails);
      break;
    case AuthUpdateAttributeStep.done:
      safePrint('Successfully updated attribute');
      break;
  }
}

void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
  safePrint(
    'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
    'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
  );
}
