<%@ Page MasterPageFile="~/View/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="AdminForm.aspx.cs" Inherits="groupware2.View.AdminForm" %>

<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <form id="form1" runat="server">
        <div class="container position-center">
            <div class="password-form custom-y-margin">
                <h3 class="text-bold text-center">관리자 인증하기</h3>
                <!-- 핀 번호 입력 폼 -->
                <div class="pin-wrapper">
                    <asp:Label ID="lblAdminPIN" runat="server" Text="PIN 4자리를 입력해주세요." CssClass="form-label" />
                    <div class="pin-container">
                        <asp:TextBox ID="txtPin1" runat="server" CssClass="pin-input" TextMode="Password" MaxLength="1" />
                        <asp:TextBox ID="txtPin2" runat="server" CssClass="pin-input" TextMode="Password" MaxLength="1" />
                        <asp:TextBox ID="txtPin3" runat="server" CssClass="pin-input" TextMode="Password" MaxLength="1" />
                        <asp:TextBox ID="txtPin4" runat="server" CssClass="pin-input" TextMode="Password" MaxLength="1" />
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script>
        // 핀 번호 입력 로직
        document.querySelectorAll('.pin-input').forEach((input, index, inputs) => {
            input.addEventListener('input', (e) => {
                if (e.target.value.length === 1 && index < inputs.length - 1) {
                    inputs[index + 1].focus();
                }
                const allFilled = Array.from(inputs).every(input => input.value.length === 1);

                // 모든 칸이 채워졌다면 자동으로 제출
                if (allFilled) {
                    submitPIN();
                }
            });

            input.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace' && e.target.value === '' && index > 0) {
                    inputs[index - 1].focus();
                }
            });
        });

        // 핀 번호 전송
        function submitPIN() {
            const pin1 = document.getElementById('<%= txtPin1.ClientID %>').value;
            const pin2 = document.getElementById('<%= txtPin2.ClientID %>').value;
            const pin3 = document.getElementById('<%= txtPin3.ClientID %>').value;
            const pin4 = document.getElementById('<%= txtPin4.ClientID %>').value;
            const pin = pin1 + pin2 + pin3 + pin4;

            const xhr = new XMLHttpRequest();
            xhr.open('POST', '<%= ResolveUrl("~/View/AdminForm.aspx") %>', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function () {
                if (xhr.status === 200) {
                    const response = JSON.parse(xhr.responseText);

                    if (response.status === "success") {
                        showAlert(response.status, response.message, "AdminList.aspx");
                    }
                    else if (response.status === "error") {
                        showAlert(response.status, response.message);
                    }
                } else {
                    alert('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                }
            };

            xhr.send('pin=' + encodeURIComponent(pin));
        }

        // 처리 결과에 따른 Alert
        function showAlert(status, message, url="") {
            let title = "경고";
            let icon = status;
            if (icon === "success") title = "성공";
            if (url === null) {
                Swal.fire({
                    title: title,
                    text: message,
                    icon: icon,
                    confirmButtonText: "확인",
                    customClass: {
                        confirmButton: "blue-btn"
                    }
                });
            } else {
                Swal.fire({
                    title: title,
                    text: message,
                    icon: icon,
                    confirmButtonText: "확인",
                    customClass: {
                        confirmButton: "blue-btn"
                    }
                }).then((result) => {
                    if (result.isConfirmed) window.location.href = url;
                });
            }
        }
    </script>
</asp:Content>
