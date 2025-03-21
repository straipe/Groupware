<%@ Page MasterPageFile="~/View/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="PasswordForm.aspx.cs" Inherits="groupware2.View.PasswordForm" %>

<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <form id="form1" runat="server">
        <div class="container position-center">
            <div class="password-form custom-y-margin">
                <h3 class="text-bold text-center">비밀번호 입력</h3>
                <!-- 개인정보 입력 -->
                <asp:Label ID="lblAuthorName" runat="server" Text="작성자 이름" CssClass="form-label" />
                <asp:TextBox ID="txtAuthorName" runat="server" CssClass="form-control" Enabled="false" />
                <asp:Label ID="lblAuthorPassword" runat="server" Text="비밀번호" CssClass="form-label" />
                <asp:TextBox ID="txtAuthorPassword" runat="server" CssClass="form-control" TextMode="Password" />
                
                <!-- 관리자 삭제 사유 -->
                <asp:Panel ID="pnlAdminDeleteOptions" runat="server" Visible="false">
                    <asp:Label ID="lblDeleteReason" runat="server" Text="삭제 사유 선택" CssClass="form-label" />   
                    <asp:DropDownList ID="ddlDeleteReason" runat="server" CssClass="form-control">
                        <asp:ListItem Text="부적절한 표현" Value="InappropriateContent"></asp:ListItem>
                        <asp:ListItem Text="개인정보 보호" Value="PersonalInfoExposed"></asp:ListItem>
                        <asp:ListItem Text="허위 정보" Value="Misinformation"></asp:ListItem>
                        <asp:ListItem Text="잘못된 카테고리" Value="WrongCategory"></asp:ListItem>
                        <asp:ListItem Text="광고/스팸" Value="SpamOrAdvertisement"></asp:ListItem>
                    </asp:DropDownList>
                </asp:Panel>

                <!-- 관리자 복원 사유 -->
                <asp:Panel ID="pnlAdminRestoreOptions" runat="server" Visible="false">
                    <asp:Label ID="lblRestoreReason" runat="server" Text="복원 사유 선택" CssClass="form-label" />   
                    <asp:DropDownList ID="ddlRestoreReason" runat="server" CssClass="form-control">
                        <asp:ListItem Text="운영진 실수로 삭제됨" Value="mistake"></asp:ListItem>
                        <asp:ListItem Text="사용자 요청에 의해 복원" Value="user_request"></asp:ListItem>
                        <asp:ListItem Text="운영 정책 변경" Value="policy_change"></asp:ListItem>
                        <asp:ListItem Text="검토 후 문제가 없음" Value="review_ok"></asp:ListItem>
                        <asp:ListItem Text="시스템 오류로 인해 삭제됨" Value="system_error"></asp:ListItem>
                        <asp:ListItem Text="운영진 판단으로 복원" Value="admin_decision"></asp:ListItem>
                    </asp:DropDownList>
                </asp:Panel>

                <!-- 버튼 -->
                <div class="row-list">
                    <asp:Button ID="btnSubmit" runat="server" Text="제출" OnClick="Btn_Click"/>
                    <asp:HyperLink ID="hlList" runat="server" Text="목록" CssClass="gray-btn"></asp:HyperLink>
                </div>
            </div>
        </div>
    </form>
</asp:Content>
