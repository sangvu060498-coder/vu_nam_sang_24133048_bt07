package vn.iotstar.controller.api;

import java.util.Date;
import java.util.Optional;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.model.Response;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.IStorageService;

@RestController
@RequestMapping("/api/product")
public class ProductApiController {

    @Autowired
    private IProductService productService;

    @Autowired
    private ICategoryService categoryService;

    @Autowired
    private IStorageService storageService;

    // 1. GET ALL PRODUCTS
    @GetMapping
    public ResponseEntity<Response> getAllProduct() {
        return ResponseEntity.ok(new Response(true, "Thành công", productService.findAll()));
    }

    // 2. GET PRODUCT BY ID
    @GetMapping("/{id}")
    public ResponseEntity<Response> getProductById(@PathVariable("id") Long id) {
        Optional<Product> opt = productService.findById(id);
        if (opt.isPresent()) {
            return ResponseEntity.ok(new Response(true, "Thành công", opt.get()));
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(new Response(false, "Không tìm thấy sản phẩm", null));
    }

    // 3. ADD PRODUCT
    @PostMapping("/addProduct")
    public ResponseEntity<Response> addProduct(
            @RequestParam("productName") String productName,
            @RequestParam("unitPrice") Double unitPrice,
            @RequestParam("quantity") Integer quantity,
            @RequestParam("discount") Double discount,
            @RequestParam("description") String description,
            @RequestParam("status") Short status,
            @RequestParam("categoryId") Long categoryId,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) {

        if (productService.findByProductName(productName).isPresent()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new Response(false, "Sản phẩm này đã tồn tại trong hệ thống", null));
        }

        Optional<Category> optCategory = categoryService.findById(categoryId);
        if (optCategory.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new Response(false, "Danh mục không tồn tại", null));
        }

        Product product = new Product();
        product.setProductName(productName);
        product.setUnitPrice(unitPrice);
        product.setQuantity(quantity);
        product.setDiscount(discount);
        product.setDescription(description);
        product.setStatus(status);
        product.setCategory(optCategory.get());
        product.setCreateDate(new Date());

        if (imageFile != null && !imageFile.isEmpty()) {
            String filename = storageService.getStorageFilename(imageFile, UUID.randomUUID().toString());
            storageService.store(imageFile, filename);
            product.setImages(filename);
        }

        productService.save(product);
        return ResponseEntity.ok(new Response(true, "Thêm sản phẩm thành công", product));
    }

    // 4. UPDATE PRODUCT
    @PutMapping("/updateProduct")
    public ResponseEntity<Response> updateProduct(
            @RequestParam("productId") Long productId,
            @RequestParam("productName") String productName,
            @RequestParam("unitPrice") Double unitPrice,
            @RequestParam("quantity") Integer quantity,
            @RequestParam("discount") Double discount,
            @RequestParam("description") String description,
            @RequestParam("status") Short status,
            @RequestParam("categoryId") Long categoryId,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile) {

        Optional<Product> optProduct = productService.findById(productId);
        if (optProduct.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new Response(false, "Không tìm thấy sản phẩm để cập nhật", null));
        }

        Optional<Category> optCategory = categoryService.findById(categoryId);
        if (optCategory.isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new Response(false, "Danh mục không tồn tại", null));
        }

        Product product = optProduct.get();
        product.setProductName(productName);
        product.setUnitPrice(unitPrice);
        product.setQuantity(quantity);
        product.setDiscount(discount);
        product.setDescription(description);
        product.setStatus(status);
        product.setCategory(optCategory.get());

        if (imageFile != null && !imageFile.isEmpty()) {
            String filename = storageService.getStorageFilename(imageFile, UUID.randomUUID().toString());
            storageService.store(imageFile, filename);
            product.setImages(filename);
        }

        productService.save(product);
        return ResponseEntity.ok(new Response(true, "Cập nhật sản phẩm thành công", product));
    }

    // 5. DELETE PRODUCT
    @DeleteMapping("/deleteProduct")
    public ResponseEntity<Response> deleteProduct(@RequestParam("productId") Long productId) {
        Optional<Product> optProduct = productService.findById(productId);
        if (optProduct.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new Response(false, "Không tìm thấy sản phẩm để xóa", null));
        }

        productService.deleteById(productId);
        return ResponseEntity.ok(new Response(true, "Xóa sản phẩm thành công", optProduct.get()));
    }
}
