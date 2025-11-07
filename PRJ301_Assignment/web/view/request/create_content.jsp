<%@ page contentType="text/html; charset=UTF-8" %>
<h3 class="mb-3"><i class="bi bi-plus-circle"></i> Create Leave Request</h3>
<form method="post" action="create" class="w-50">
    <div class="mb-3">
        <label class="form-label">From</label>
        <input type="date" name="from" class="form-control" required>
    </div>
    <div class="mb-3">
        <label class="form-label">To</label>
        <input type="date" name="to" class="form-control" required>
    </div>
    <div class="mb-3">
        <label class="form-label">Reason</label>
        <textarea name="reason" class="form-control" rows="3" required></textarea>
    </div>
    <button class="btn btn-primary">Submit</button>
</form>
