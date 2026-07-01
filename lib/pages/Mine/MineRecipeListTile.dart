import 'package:flutter/material.dart';
import 'package:fondia/models/interaction_models.dart';
import 'package:fondia/pages/CategoryDetail/DishDetail.dart';
import 'package:fondia/utils/recipe_image.dart';

String formatInteractionCount(int? count) {
  if (count == null || count <= 0) return '0';
  if (count >= 10000) {
    return '${(count / 10000).toStringAsFixed(1)}万';
  }
  return count.toString();
}

String formatActionTimeLabel(String? time) {
  if (time == null || time.isEmpty) return '';
  if (time.length >= 16) return time.substring(0, 16);
  return time;
}

class MineRecipeListTile extends StatelessWidget {
  final MineRecipeItem item;
  final IconData trailingIcon;
  final Color trailingColor;
  final VoidCallback? onTrailingTap;

  const MineRecipeListTile({
    super.key,
    required this.item,
    required this.trailingIcon,
    required this.trailingColor,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DishDetail(recipeId: item.recipeId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 72,
                height: 72,
                child: RecipeImage(url: item.coverImage, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onTrailingTap,
                        child: Icon(trailingIcon, color: trailingColor, size: 20),
                      ),
                    ],
                  ),
                  if (item.subtitle != null && item.subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        item.subtitle!,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye_outlined,
                          size: 12, color: Colors.grey),
                      Text(
                        ' ${formatInteractionCount(item.viewCount)}',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      if (item.actionTime != null)
                        Text(
                          formatActionTimeLabel(item.actionTime),
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      const Spacer(),
                      if (item.tags.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.tags.first,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
