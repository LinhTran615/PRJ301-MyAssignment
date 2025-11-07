<%@ page contentType="text/html; charset=UTF-8" %>
<h3 class="mb-3"><i class="bi bi-check2-square"></i> Review Leave Request</h3>
<p><strong>Employee:</strong> ${request.created_by.name}</p>
<p><strong>From:</strong> ${request.from}</p>
<p><strong>To:</strong> ${request.to}</p>
<p><strong>Reason:</strong> ${request.reason}</p>

<form action="review" method="post">
    <input type="hidden" name="rid" value="${request.id}">
    <div class="mt-3">
        <button name="status" value="1" class="btn btn-success me-2"><i class="bi bi-check2"></i> Approve</button>
        <button name="status" value="2" class="btn btn-danger"><i class="bi bi-x-lg"></i> Reject</button>
    </div>
</form>
