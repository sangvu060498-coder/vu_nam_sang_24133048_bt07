<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Sản Phẩm (Product) - AJAX</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>var contextPath = "${pageContext.request.contextPath}";</script>
</head>
<body class="bg-light">
<div class="container-fluid my-5 px-4">
    <div class="card shadow-sm">
        <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
            <h4 class="mb-0">Quản Lý Sản Phẩm (Product) - RESTful API & AJAX</h4>
            <div>
                <a href="${pageContext.request.contextPath}/admin/category-ajax" class="btn btn-light btn-sm me-2">Sang Quản Lý Category</a>
                <button class="btn btn-dark btn-sm" onclick="showAddProductModal()"><i class="fas fa-plus"></i> Thêm Sản Phẩm Mới</button>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle" id="productTable">
                    <thead class="table-dark text-center">
                        <tr>
                            <th>ID</th>
                            <th>Hình ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Giá gốc</th>
                            <th>Giảm giá</th>
                            <th>Số lượng</th>
                            <th>Danh mục</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody class="text-center"></tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal Thêm Product -->
<div class="modal fade" id="addProductModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="formAddProduct" enctype="multipart/form-data">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Sản Phẩm Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Tên sản phẩm:</label>
                        <input type="text" class="form-control" name="productName" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Danh mục (Category):</label>
                        <select class="form-select selectCategory" name="categoryId" required></select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Đơn giá (VNĐ):</label>
                        <input type="number" step="0.01" class="form-control" name="unitPrice" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Khuyến mãi / Giảm giá (%):</label>
                        <input type="number" step="0.01" class="form-control" name="discount" value="0" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Số lượng:</label>
                        <input type="number" class="form-control" name="quantity" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Trạng thái:</label>
                        <select class="form-select" name="status">
                            <option value="1">Đang bán</option>
                            <option value="0">Ngừng bán</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Ảnh sản phẩm:</label>
                        <input type="file" class="form-control" name="imageFile">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Mô tả sản phẩm:</label>
                        <textarea class="form-control" name="description" rows="3" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary">Lưu sản phẩm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Sửa Product -->
<div class="modal fade" id="editProductModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form id="formEditProduct" enctype="multipart/form-data">
                <div class="modal-header">
                    <h5 class="modal-title">Cập Nhật Sản Phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body row g-3">
                    <input type="hidden" id="edit_productId" name="productId">
                    <div class="col-md-6">
                        <label class="form-label">Tên sản phẩm:</label>
                        <input type="text" class="form-control" id="edit_productName" name="productName" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Danh mục (Category):</label>
                        <select class="form-select selectCategory" id="edit_categoryId" name="categoryId" required></select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Đơn giá (VNĐ):</label>
                        <input type="number" step="0.01" class="form-control" id="edit_unitPrice" name="unitPrice" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Khuyến mãi / Giảm giá (%):</label>
                        <input type="number" step="0.01" class="form-control" id="edit_discount" name="discount" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Số lượng:</label>
                        <input type="number" class="form-control" id="edit_quantity" name="quantity" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Trạng thái:</label>
                        <select class="form-select" id="edit_status" name="status">
                            <option value="1">Đang bán</option>
                            <option value="0">Ngừng bán</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Đổi ảnh sản phẩm:</label>
                        <input type="file" class="form-control" name="imageFile">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Ảnh hiện tại:</label>
                        <div id="current_product_image"></div>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Mô tả sản phẩm:</label>
                        <textarea class="form-control" id="edit_description" name="description" rows="3" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-success">Cập nhật sản phẩm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(document).ready(function() {
    loadProducts();
    loadCategoryDropdown();

    // Form submit thêm Product
    $('#formAddProduct').on('submit', function(e) {
        e.preventDefault();
        var formData = new FormData(this);
        $.ajax({
            url: contextPath + '/api/product/addProduct',
            type: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            success: function(res) {
                alert(res.message);
                $('#addProductModal').modal('hide');
                $('#formAddProduct')[0].reset();
                loadProducts();
            },
            error: function(err) {
                alert(err.responseJSON ? err.responseJSON.message : "Thất bại khi thêm sản phẩm!");
            }
        });
    });

    // Form submit cập nhật Product
    $('#formEditProduct').on('submit', function(e) {
        e.preventDefault();
        var formData = new FormData(this);
        $.ajax({
            url: contextPath + '/api/product/updateProduct',
            type: 'PUT',
            data: formData,
            contentType: false,
            processData: false,
            success: function(res) {
                alert(res.message);
                $('#editProductModal').modal('hide');
                loadProducts();
            },
            error: function(err) {
                alert(err.responseJSON ? err.responseJSON.message : "Thất bại khi cập nhật sản phẩm!");
            }
        });
    });
});

// Load danh sách sản phẩm
function loadProducts() {
    $.getJSON(contextPath + '/api/product', function(res) {
        var rows = '';
        var data = res.body;
        $.each(data, function(i, item) {
            var imgTag = item.images ? '<img src="' + contextPath + '/uploads/' + item.images + '" style="height:60px;" class="img-thumbnail"/>' : '<span class="text-muted">Chưa có</span>';
            var statusText = item.status == 1 ? '<span class="badge bg-success">Đang bán</span>' : '<span class="badge bg-secondary">Ngừng bán</span>';
            var categoryName = item.category ? item.category.categoryName : 'N/A';

            rows += '<tr>' +
                '<td>' + item.productId + '</td>' +
                '<td>' + imgTag + '</td>' +
                '<td class="text-start"><strong>' + item.productName + '</strong></td>' +
                '<td>' + item.unitPrice.toLocaleString() + ' đ</td>' +
                '<td>' + item.discount + ' %</td>' +
                '<td>' + item.quantity + '</td>' +
                '<td><span class="badge bg-info text-dark">' + categoryName + '</span></td>' +
                '<td>' + statusText + '</td>' +
                '<td>' +
                    '<button class="btn btn-sm btn-warning me-2" onclick="showEditProductModal(' + item.productId + ')"><i class="fas fa-edit"></i></button>' +
                    '<button class="btn btn-sm btn-danger" onclick="deleteProduct(' + item.productId + ')"><i class="fas fa-trash"></i></button>' +
                '</td>' +
            '</tr>';
        });
        $('#productTable tbody').html(rows);
    });
}

// Load danh mục vào thẻ select
function loadCategoryDropdown() {
    $.getJSON(contextPath + '/api/category', function(res) {
        var options = '<option value="">-- Chọn danh mục --</option>';
        $.each(res.body, function(i, cat) {
            options += '<option value="' + cat.categoryId + '">' + cat.categoryName + '</option>';
        });
        $('.selectCategory').html(options);
    });
}

function showAddProductModal() {
    $('#formAddProduct')[0].reset();
    $('#addProductModal').modal('show');
}

function showEditProductModal(id) {
    $.getJSON(contextPath + '/api/product/' + id, function(res) {
        var p = res.body;
        $('#edit_productId').val(p.productId);
        $('#edit_productName').val(p.productName);
        $('#edit_unitPrice').val(p.unitPrice);
        $('#edit_discount').val(p.discount);
        $('#edit_quantity').val(p.quantity);
        $('#edit_description').val(p.description);
        $('#edit_status').val(p.status);
        $('#edit_categoryId').val(p.category ? p.category.categoryId : '');
        
        if (p.images) {
            $('#current_product_image').html('<img src="' + contextPath + '/uploads/' + p.images + '" style="height:60px;" class="img-thumbnail"/>');
        } else {
            $('#current_product_image').html('<span class="text-muted">Không có ảnh</span>');
        }
        $('#editProductModal').modal('show');
    });
}

function deleteProduct(id) {
    if (confirm('Bạn có chắc chắn muốn xóa sản phẩm ID ' + id + '?')) {
        $.ajax({
            url: contextPath + '/api/product/deleteProduct?productId=' + id,
            type: 'DELETE',
            success: function(res) {
                alert(res.message);
                loadProducts();
            },
            error: function() {
                alert('Xóa sản phẩm thất bại!');
            }
        });
    }
}
</script>
</body>
</html>
