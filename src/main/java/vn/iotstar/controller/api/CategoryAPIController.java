package vn.iotstar.controller.api;

import java.util.Optional;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.iotstar.entity.Category;
import vn.iotstar.model.Response;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IStorageService;

@RestController
@RequestMapping("/api/category")
public class CategoryAPIController {

    @Autowired
    private ICategoryService categoryService;

    @Autowired
    private IStorageService storageService;

    @GetMapping
    public ResponseEntity<Response> getAllCategory() {
        return ResponseEntity.ok(new Response(true, "Thành công", categoryService.findAll()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Response> getCategoryById(@PathVariable("id") Long id) {
        Optional<Category> category = categoryService.findById(id);
        if (category.isPresent()) {
            return ResponseEntity.ok(new Response(true, "Thành công", category.get()));
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(new Response(false, "Không tìm thấy Category", null));
    }

    @PostMapping("/addCategory")
    public ResponseEntity<Response> addCategory(
            @RequestParam("categoryName") String categoryName,
            @RequestParam(value = "icon", required = false) MultipartFile icon) {
        
        if (categoryService.findByCategoryName(categoryName).isPresent()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new Response(false, "Category đã tồn tại trong hệ thống", null));
        }

        Category category = new Category();
        category.setCategoryName(categoryName);

        if (icon != null && !icon.isEmpty()) {
            String filename = storageService.getStorageFilename(icon, UUID.randomUUID().toString());
            storageService.store(icon, filename);
            category.setIcon(filename);
        }

        categoryService.save(category);
        return ResponseEntity.ok(new Response(true, "Thêm Category thành công", category));
    }

    @PutMapping("/updateCategory")
    public ResponseEntity<Response> updateCategory(
            @RequestParam("categoryId") Long categoryId,
            @RequestParam("categoryName") String categoryName,
            @RequestParam(value = "icon", required = false) MultipartFile icon) {
        
        Optional<Category> optCategory = categoryService.findById(categoryId);
        if (optCategory.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new Response(false, "Không tìm thấy Category để cập nhật", null));
        }

        Category category = optCategory.get();
        category.setCategoryName(categoryName);

        if (icon != null && !icon.isEmpty()) {
            String filename = storageService.getStorageFilename(icon, UUID.randomUUID().toString());
            storageService.store(icon, filename);
            category.setIcon(filename);
        }

        categoryService.save(category);
        return ResponseEntity.ok(new Response(true, "Cập nhật Category thành công", category));
    }

    @DeleteMapping("/deleteCategory")
    public ResponseEntity<Response> deleteCategory(@RequestParam("categoryId") Long categoryId) {
        Optional<Category> optCategory = categoryService.findById(categoryId);
        if (optCategory.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new Response(false, "Không tìm thấy Category để xóa", null));
        }

        categoryService.deleteById(categoryId);
        return ResponseEntity.ok(new Response(true, "Xóa Category thành công", optCategory.get()));
    }
}
