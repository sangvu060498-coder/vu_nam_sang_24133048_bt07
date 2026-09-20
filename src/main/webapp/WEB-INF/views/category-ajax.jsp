<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Category - AJAX</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>var contextPath = "${pageContext.request.contextPath}";</script>
</head>
<body class="bg-light">
<div class="container my-5">
    <div class="card shadow-sm">
        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
            <h4 class="mb-0">Quản Lý Danh Mục (Category) - AJAX</h4>
            <div>
                <a href="${pageContext.request.contextPath}/admin/product-ajax" class="btn btn-warning btn-sm me-2">Sang Quản Lý Product</a>
                <button class="btn btn-success btn-sm" onclick="showAddModal()"><i class="fas fa-plus"></i> Thêm mới</button>
            </div>
        </div>
        <div class="card-body">
            <table class="table table-bordered table-hover align-middle" id="categoryTable">
                <thead class="table-dark text-center">
                    <tr>
                        <th width="10%">ID</th>
                        <th width="20%">Icon</th>
                        <th>Tên Danh Mục</th>
                        <th width="20%">Hành Động</th>
                    </tr>
                </thead>
                <tbody class="text-center"></tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Thêm Category -->
<div class="modal fade" id="addCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="formAddCategory" enctype="multipart/form-data">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Danh Mục Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên danh mục:</label>
                        <input type="text" class="form-control" name="categoryName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Icon / Hình ảnh:</label>
                        <input type="file" class="form-control" name="icon">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Sửa Category -->
<div class="modal fade" id="editCategoryModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="formEditCategory" enctype="multipart/form-data">
                <div class="modal-header">
                    <h5 class="modal-title">Cập Nhật Danh Mục</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="edit_categoryId" name="categoryId">
                    <div class="mb-3">
                        <label class="form-label">Tên danh mục:</label>
                        <input type="text" class="form-control" id="edit_categoryName" name="categoryName" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Icon hiện tại:</label>
                        <div id="current_icon_preview"></div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Chọn icon mới (nếu muốn đổi):</label>
                        <input type="file" class="form-control" name="icon">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-success">Cập nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap 5 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(document).ready(function() {
    loadCategories();

    // Submit Thêm Category
    $('#formAddCategory').on('submit', function(e) {
        e.preventDefault();
        var formData = new FormData(this);
        $.ajax({
            url: contextPath + '/api/category/addCategory',
            type: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            success: function(res) {
                alert(res.message);
                $('#addCategoryModal').modal('hide');
                $('#formAddCategory')[0].reset();
                loadCategories();
            },
            error: function(err) {
                alert(err.responseJSON ? err.responseJSON.message : "Thất bại!");
            }
        });
    });

    // Submit Sửa Category
    $('#formEditCategory').on('submit', function(e) {
        e.preventDefault();
        var formData = new FormData(this);
        $.ajax({
            url: contextPath + '/api/category/updateCategory',
            type: 'PUT',
            data: formData,
            contentType: false,
            processData: false,
            success: function(res) {
                alert(res.message);
                $('#editCategoryModal').modal('hide');
                loadCategories();
            },
            error: function(err) {
                alert(err.responseJSON ? err.responseJSON.message : "Cập nhật thất bại!");
            }
        });
    });
});

function loadCategories() {
    $.getJSON(contextPath + '/api/category', function(res) {
        var rows = '';
        var data = res.body;
        $.each(data, function(i, item) {
            var iconImg = item.icon ? '<img src="' + contextPath + '/uploads/' + item.icon + '" style="height:50px;" class="img-thumbnail"/>' : '<span class="text-muted">Không có</span>';
            rows += '<tr>' +
                '<td>' + item.categoryId + '</td>' +
                '<td>' + iconImg + '</td>' +
                '<td>' + item.categoryName + '</td>' +
                '<td>' +
                    '<button class="btn btn-sm btn-warning me-2" onclick="showEditModal(' + item.categoryId + ', \'' + item.categoryName + '\', \'' + (item.icon || '') + '\')"><i class="fas fa-edit"></i></button>' +
                    '<button class="btn btn-sm btn-danger" onclick="deleteCategory(' + item.categoryId + ')"><i class="fas fa-trash"></i></button>' +
                '</td>' +
            '</tr>';
        });
        $('#categoryTable tbody').html(rows);
    });
}

function showAddModal() {
    $('#formAddCategory')[0].reset();
    $('#addCategoryModal').modal('show');
}

function showEditModal(id, name, icon) {
    $('#edit_categoryId').val(id);
    $('#edit_categoryName').val(name);
    if(icon) {
        $('#current_icon_preview').html('<img src="' + contextPath + '/uploads/' + icon + '" style="height:50px;" class="img-thumbnail"/>');
    } else {
        $('#current_icon_preview').html('<span class="text-muted">Chưa có</span>');
    }
    $('#editCategoryModal').modal('show');
}

function deleteCategory(id) {
    if (confirm('Bạn có chắc chắn muốn xóa danh mục ID ' + id + '?')) {
        $.ajax({
            url: contextPath + '/api/category/deleteCategory?categoryId=' + id,
            type: 'DELETE',
            success: function(res) {
                alert(res.message);
                loadCategories();
            },
            error: function() {
                alert('Không thể xóa danh mục này (có thể do đã có sản phẩm ràng buộc)!');
            }
        });
    }
}
</script>
</body>
</html>
