class Budget {
  Budget({
    required this.title,
    required this.value,
  });
  String title;
  String value;
}

List<Budget> budgetList = <Budget>[
  Budget(title: 'Under Rs. 100000', value: '100000'),
  Budget(title: 'Under Rs. 50000', value: '50000'),
  Budget(title: 'Under Rs. 10000', value: '10000'),
  Budget(title: 'Under Rs. 5000', value: '5000'),
  Budget(title: 'Under Rs. 3000', value: '3000'),
];
