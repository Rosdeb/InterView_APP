import 'package:app_interview/Controller/ProductController/product_controller.dart';
import 'package:app_interview/Views/Base/CustomTextfield/CustomTextfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Models/user_model/user_model.dart';
import 'home_constant.dart';
import 'profile_sheet.dart';

/// Search bar widget with search input and user avatar.
/// Displays at the bottom of the collapsible header.
class HomeSearchBar extends StatelessWidget {
  final bool isDark;
  final bool collapsed;
  final UserModel? user;
  final TextEditingController searchController;

  const HomeSearchBar({
    required this.isDark,
    required this.collapsed,
    required this.user,
    required this.searchController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Container(
      color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: kSearchPadV,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: kSearchH,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2C2C2E)
                    : Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search_rounded,
                      size: 20, color: Color(0xFF8E8E93)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      borderColor: Colors.transparent,
                      hintText: '..search',
                      onChanged: controller.onSearchChanged,
                      controller: searchController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B00).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        size: 16, color: Color(0xFFFF6B00)),
                  ),
                ],
              ),
            ),
          ),
          if (collapsed && user != null) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => ProfileSheet(user: user!),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFFF6B00),
                child: Text(
                  user!.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}