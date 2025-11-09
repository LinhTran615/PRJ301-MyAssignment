<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    .filter-bar{
        display:grid;
        grid-template-columns: 220px 1fr 120px;
        gap:10px;
        align-items:end;
        margin-bottom:12px;
    }
    .filter-bar .field{
        display:flex;
        flex-direction:column;
    }
    .filter-bar .label{
        font-size:12px;
        color:#64748b;
        margin-bottom:4px;
    }
    .filter-bar .input, .filter-bar .btn{
        padding:9px 10px;
        border:1px solid #e5e7eb;
        border-radius:8px;
    }
    .filter-bar .btn{
        background:#3b82f6;
        color:#fff;
        border:1px solid transparent;
        cursor:pointer;
    }
    .filter-bar .btn:hover{
        background:#2563eb;
    }

    .agenda-wrap{
        display:flex;
        flex-direction:column;
        gap:12px;
    }
    .legend{
        display:flex;
        gap:10px;
        font-size:14px;
        color:#475569;
        margin-bottom:6px;
    }
    .legend .sw{
        width:12px;
        height:12px;
        border-radius:3px;
        display:inline-block;
        margin-right:6px;
    }
    .sw-working{
        background:#e8f5e9;
        border:1px solid #b7e1c1;
    }
    .sw-off{
        background:#fee2e2;
        border:1px solid #fecaca;
    }
    .sw-proc{
        background:#fff7ed;
        border:1px solid #fde68a;
    }

    .agenda-table{
        width:100%;
        border-collapse:separate;
        border-spacing:0;
        background:#fff;
        border:1px solid #e5e7eb;
        border-radius:12px;
        overflow:hidden;
    }
    .agenda-table thead th{
        position:sticky;
        top:0;
        background:#f8fafc;
        font-weight:700;
        color:#334155;
        padding:10px 8px;
        border-bottom:1px solid #e5e7eb;
        white-space:nowrap;
    }
    .agenda-table tbody td, .agenda-table tbody th{
        padding:8px;
        border-bottom:1px solid #f1f5f9;
        border-right:1px solid #f8fafc;
    }
    .agenda-table tbody tr:last-child td, .agenda-table tbody tr:last-child th{
        border-bottom:none;
    }
    .agenda-table tbody th{
        position:sticky;
        left:0;
        background:#fff;
        z-index:1;
        text-align:left;
        min-width:220px;
    }
    .cell{
        height:28px;
        border-radius:6px;
    }
    .cell-working{
        background:#e8f5e9;
    }
    .cell-off{
        background:#fee2e2;
    }
    .cell-proc{
        background:#fff7ed;
    }
    .date-sub{
        font-size:11px;
        color:#64748b;
        display:block;
        margin-top:2px;
    }
    .tbl-scroll{
        overflow:auto;
        max-height:70vh;
    }
</style>

<form method="get" action="${pageContext.request.contextPath}/division/agenda" class="filter-bar">
    <div class="field">
        <label class="label">Tháng</label>
        <input type="month" name="month" class="input" value="${month}" />
    </div>
    <div class="field">
        <label class="label">Tên nhân sự</label>
        <input type="text" name="name" class="input" placeholder="Nhập tên…" value="${name}" />
    </div>
    <button class="btn" type="submit">Lọc</button>
</form>

<div class="agenda-wrap">
    <div class="legend">
        <span><span class="sw sw-working"></span>Đi làm</span>
        <span><span class="sw sw-off"></span>Nghỉ (Approved)</span>
        <%-- <span><span class="sw sw-proc"></span>Đơn chờ duyệt</span> --%>
    </div>

    <div class="tbl-scroll">
        <table class="agenda-table">
            <thead>
                <tr>
                    <th>Nhân viên</th>
                        <c:forEach var="d" items="${days}">
                        <th>
                <fmt:formatDate value="${d}" pattern="dd/MM"/>
                <span class="date-sub"><fmt:formatDate value="${d}" pattern="EEE"/></span>
                </th>
            </c:forEach>
            </tr>
            </thead>
            <tbody>
                <c:forEach var="row" items="${rows}">
                    <tr>
                        <th>${row.emp.name}</th>
                            <c:forEach var="v" items="${row.cells}">
                            <td>
                                <c:choose>
                                    <c:when test="${v == 1}">
                                        <div class="cell cell-off" title="Nghỉ"></div>
                                    </c:when>
                                    <c:when test="${v == 2}">
                                        <div class="cell cell-proc" title="Đơn chờ duyệt"></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="cell cell-working" title="Đi làm"></div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>

                <c:if test="${empty rows}">
                    <tr>
                        <td colspan="${fn:length(days) + 1}" style="text-align:center; color:#64748b; padding:18px;">
                            Không có nhân sự phù hợp bộ lọc.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
