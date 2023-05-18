import '../../../data/models/local_model/checkout_model.dart';

class CalculateAmount {
  num getTotalAmountofTour({CheckOutModel? checkOutModel}) {
    final int adultCount = checkOutModel!.adultCount!;
    final int chidrenCount = checkOutModel.childrenCount!;
    final num adultAmount = checkOutModel.offerAmount != 0
        ? checkOutModel.offerAmount! * adultCount
        : checkOutModel.amount! * adultCount;
    final num kidsAmount = checkOutModel.kidsOfferAmount != 0
        ? checkOutModel.kidsOfferAmount! * chidrenCount
        : checkOutModel.kidsAmount! * chidrenCount;
    final num totalAmount = adultAmount + kidsAmount;
    return totalAmount;
  }

  num getGSTPercentageAmount({CheckOutModel? checkOutModel}) {
    final num totalAmount = getTotalAmounttoBepaidByTheUser();
    final double gst = (totalAmount * checkOutModel!.gst!) / 100;
    return gst;
  }

  num getCGSTPercentageAmount({CheckOutModel? checkOutModel}) {
    final num totalAmount = getTotalAmounttoBepaidByTheUser();
    final double cgstPercentage = checkOutModel!.gst! / 2;
    final double sgst = (totalAmount * cgstPercentage) / 100;
    return sgst;
  }

  num getSGSTPercentageAmount({CheckOutModel? checkOutModel}) {
    final num totalAmount = getTotalAmounttoBepaidByTheUser();
    final double sgstpercentage = checkOutModel!.gst! / 2;
    final double sgst = (totalAmount * sgstpercentage) / 100;
    return sgst;
  }

  num getTotalAmounttoBepaidByTheUser({String? currentUserCategory}) {
    final num commissionAmount = getCommisionAmount();
    final num totalAmount = getTotalAmountofTour();
    final num sum;
    currentUserCategory == 'standard'
        ? sum = totalAmount
        : sum = totalAmount - commissionAmount;
    return sum;
  }

  int getTotalPassengers({CheckOutModel? checkOutModel}) {
    final int totalPassenegrs =
        checkOutModel!.adultCount! + checkOutModel.childrenCount!;
    return totalPassenegrs;
  }

  num getCommisionAmount({CheckOutModel? checkOutModel}) {
    final num commission = checkOutModel!.commission!;
    final int totalPassenegrs = getTotalPassengers();
    final num sum = commission * totalPassenegrs;
    return sum;
  }

  num getGrandTotal() {
    final num gst = getGSTPercentageAmount();
    final num totalAmount = getTotalAmounttoBepaidByTheUser();
    final num grandTotal = totalAmount + gst;
    return grandTotal;
  }
}
