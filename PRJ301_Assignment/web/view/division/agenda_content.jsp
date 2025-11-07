<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="panel">
  <div class="panel-head">Lịch nghỉ của phòng</div>
  <table class="table">
    <thead>
      <tr>
        <th>Nhân sự</th>
        <th>Từ</th>
        <th>Đến</th>
        <th>Lý do</th>
        <th>Trạng thái</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="r" items="${requests}">
        <tr>
          <td>${r.created_by.name}</td>
          <td>${r.from}</td>
          <td>${r.to}</td>
          <td>${r.reason}</td>
          <td>
            <c:choose>
              <c:when test="${r.status eq 0}"><span class="badge badge-warn">Processing</span></c:when>
              <c:when test="${r.status eq 1}"><span class="badge badge-ok">Approved</span></c:when>
              <c:otherwise><span class="badge badge-bad">Rejected</span></c:otherwise>
            </c:choose>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>
