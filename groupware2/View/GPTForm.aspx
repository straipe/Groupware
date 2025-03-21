<%@ Page MasterPageFile="~/View/Site.Master" Language="C#" AutoEventWireup="true" CodeBehind="GPTForm.aspx.cs" Inherits="groupware2.View.GPTForm" %>

<asp:Content ID="Content" ContentPlaceHolderID="Content" runat="server">
    <form id="form1" runat="server">
        <div class="container">
            <h3 class="text-bold">Dongwon GPT</h3>
            <div class="gpt-container form-label">
                <div style="height:500px; display:grid; place-items: center;">
                    <div class="text-center">
                        <h1 style="margin-bottom:20px;">Welcome to Dongwon GPT</h1>
                        <p>사용된 질의와 답변은 외부로 유출되지 않으며, </p>
                        <p>동원GPT의 학습 데이터로도 활용되지 않아 안전하게 사용하실 수 있습니다.</p>
                    </div>
                </div>
            </div>
            <div class="row-list" style="width: 90%; margin: 0 auto;">
                <asp:TextBox ID="txtPrompt" runat="server" TextMode="MultiLine" CssClass="styled-textarea" PlaceHolder="내용을 입력해주세요." onkeydown="handler(event);"></asp:TextBox>
                <button id="btnSubmit" type="button" class="sky-btn styled-btn" onclick="send()">Send</button>
            </div>
        </div>
    </form>
    <!-- SignalR -->
    <script src="/Scripts/jquery-3.7.1.min.js"></script>
    <script src="/Scripts/jquery.signalR-2.4.3.min.js"></script>
    <script src="/signalr/hubs"></script>

    <script>
        let gptHub;
        let responseText;
        let firstRequest = true;

        $(function () {
            gptHub = $.connection.chatGPTHub;

            gptHub.client.ReceiveAsync = function (content) {
                responseText.innerHTML = content;
            }


            window.send = function () {
                let prompt = document.getElementById("Content_txtPrompt").value;
                if (!prompt.trim()) return;

                let GPTContainer = document.querySelector(".gpt-container");
                if (firstRequest) {
                    GPTContainer.innerHTML = "";
                    firstRequest = false;
                }
                // 새 질문 항목 생성
                let requestContainer = document.createElement("div");
                requestContainer.setAttribute("class", "gpt-row-box");
                requestContainer.style = "justify-content: flex-end";

                let requestBox = document.createElement("div");
                requestBox.setAttribute("class", "gpt-text-box form-label");
                requestBox.innerText = prompt;

                requestContainer.appendChild(requestBox);
                GPTContainer.appendChild(requestContainer);


                // 새 응답 항목 생성
                responseContainer = document.createElement("div");
                responseContainer.setAttribute("class", "gpt-row-box");

                let dongwonLogo = document.createElement("span");
                dongwonLogo.setAttribute("class", "gpt-logo");
                dongwonLogo.innerText = "D";
                responseContainer.appendChild(dongwonLogo);

                responseText = document.createElement("div");
                responseText.setAttribute("class", "form-label");
                responseText.style = "line-height: 45px;";
                responseText.innerHTML = "GPT 응답을 불러오는 중...";
                responseContainer.appendChild(responseText);

                GPTContainer.appendChild(responseContainer);

                gptHub.server.getGPTResponse(prompt);

                GPTContainer.scrollTop = GPTContainer.scrollHeight;

                document.getElementById("Content_txtPrompt").value = "";
            }

            document.getElementById("btnSubmit").addEventListener("click", send());

            $.connection.hub.start().done(function () {
                console.log("GPT 통신용 웹소켓 연결 완료!")
            })
        })

        function handler(event) {
            if (event.key === "Enter" && !event.shiftKey) {
                event.preventDefault();
                send();
            }
        }
    </script>
</asp:Content>