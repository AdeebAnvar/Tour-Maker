class CalculateAmount {
  num getAmountofTourPackageIncludingGST({
    required int adultCount,
    required int childrenCount,
    required num offerAmount,
    required num kidsOfferAmount,
    required num amount,
    required num kidsAmount,
    required num gst,
  }) {
    final num adultAmount;
    if (offerAmount != 0) {
      adultAmount = offerAmount * adultCount;
    } else {
      adultAmount = amount * adultCount;
    }
    final num childrenAmount;
    if (kidsOfferAmount != 0) {
      childrenAmount = kidsOfferAmount * childrenCount;
    } else {
      childrenAmount = kidsAmount * childrenCount;
    }
    final num totalAmount = adultAmount + childrenAmount;
    final num gstAmount = (totalAmount * gst) / 100;
    final num sum = totalAmount + gstAmount;
    return sum;
  }

  num getAmountofTourPackageExcludingGST({
    required int adultCount,
    required int childrenCount,
    required num offerAmount,
    required num kidsOfferAmount,
    required num amount,
    required num kidsAmount,
    required num gst,
  }) {
    final num adultAmount;
    if (offerAmount != 0) {
      adultAmount = offerAmount * adultCount;
    } else {
      adultAmount = amount * adultCount;
    }
    final num childrenAmount;
    if (kidsOfferAmount != 0) {
      childrenAmount = kidsOfferAmount * childrenCount;
    } else {
      childrenAmount = kidsAmount * childrenCount;
    }
    final num totalAmount = adultAmount + childrenAmount;

    return totalAmount;
  }

  num getGSTAmount({required num amountofPackage, required num gstPercentage}) {
    final double gst = (amountofPackage * gstPercentage) / 100;
    return gst;
  }

  num getCGSTAmount(
      {required num amountofPackage, required num gstPercentage}) {
    final double cgstpercentage = gstPercentage / 2;

    final double cgst = (amountofPackage * cgstpercentage) / 100;
    return cgst;
  }

  num getSGSTAmount(
      {required num amountofPackage, required num gstPercentage}) {
    final double sgstpercentage = gstPercentage / 2;
    final double sgst = (amountofPackage * sgstpercentage) / 100;
    return sgst;
  }

  num getGrandTotalAmount(
      {required String currentUserCategory,
      required num commission,
      required num packageAmount,
      required num gst}) {
    final num sum;
    currentUserCategory == 'standard'
        ? sum = packageAmount
        : sum = packageAmount - commission;
    return sum;
  }

  int getTotalPassengersCount(
      {required int adultCount, required int childrenCount}) {
    final int totalPassenegrs = adultCount + childrenCount;
    return totalPassenegrs;
  }

  num getCommisionAmount(
      {required num commission, required int totalPassengers}) {
    final num sum = commission * totalPassengers;
    return sum;
  }
}
