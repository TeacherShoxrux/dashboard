import 'package:flutter/material.dart';

class CustomerSearchWidget extends StatefulWidget {
  const CustomerSearchWidget({super.key});

  @override
  State<CustomerSearchWidget> createState() => _CustomerSearchWidgetState();
}

class _CustomerSearchWidgetState extends State<CustomerSearchWidget> {
  // Qidiruv turlari ro'yxati
  final List<Map<String, String>> _searchTypes = [
    {'value': 'jshshir', 'label': 'JSHSHIR'},
    {'value': 'firstname', 'label': 'Ismi'},
    {'value': 'lastname', 'label': 'Familiyasi'},
    {'value': 'phone', 'label': 'Telefon'},
  ];

  String _selectedType = 'jshshis'; // Default tanlangan tur
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _selectedType = _searchTypes[0]['value']!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        return Container(
          // padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            // color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              if (isMobile)
                _buildMobileLayout()
              else

                _buildDesktopLayout(),
            ],
          ),
        );
      },
    );
  }

  // Mobil uchun layout
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildDropdown(),
        const SizedBox(height: 12),
        _buildTextField(),
      ],
    );
  }

  // Desktop/Web uchun layout
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        SizedBox(width: 150, child: _buildDropdown()),
        const SizedBox(width: 12),
        Expanded(child: _buildTextField()),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => _handleSearch(),
          icon: const Icon(Icons.search),
          label: const Text("Qidirish"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        )
      ],
    );
  }

  // Dropdown vidjeti
  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      decoration: InputDecoration(
        labelText: "Turini tanlang",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      items: _searchTypes.map((type) {
        return DropdownMenuItem(
          value: type['value'],
          child: Text(type['label']!),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedType = value!;
        });
      },
    );
  }

  // TextField vidjeti
  Widget _buildTextField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "${_searchTypes.firstWhere((e) => e['value'] == _selectedType)['label']} bo'yicha qidiruv...",
        prefixIcon: const Icon(Icons.person_search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => _searchController.clear(),
        ),
      ),
      onSubmitted: (_) => _handleSearch(),
    );
  }

  void _handleSearch() {
    print("Qidiruv turi: $_selectedType");
    print("Qiymat: ${_searchController.text}");
    // Bu yerda API chaqiruvi yoki filtrlash funksiyasi bo'ladi
  }
}