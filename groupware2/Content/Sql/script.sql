USE [groupware2]
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 2025-02-14 오전 9:15:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 2025-02-14 오전 9:15:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Content] [nvarchar](max) NULL,
	[AuthorName] [nvarchar](max) NULL,
	[AuthorPassword] [nvarchar](max) NULL,
	[AuthorEmail] [nvarchar](max) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[IsRemove] [bit] NOT NULL,
	[PostId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Comments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Documents]    Script Date: 2025-02-14 오전 9:15:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Documents](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Content] [nvarchar](max) NULL,
	[AuthorName] [nvarchar](max) NULL,
	[IsRemove] [bit] NOT NULL,
	[PostId] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.Documents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Posts]    Script Date: 2025-02-14 오전 9:15:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Posts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Content] [nvarchar](max) NULL,
	[AuthorName] [nvarchar](max) NULL,
	[AuthorPassword] [nvarchar](max) NULL,
	[AuthorEmail] [nvarchar](max) NULL,
	[IsRemove] [bit] NOT NULL,
	[HasDocument] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.Posts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'202502130817340_InitialCreate', N'groupware2.Migrations.Configuration', 0x1F8B0800000000000400ED5A4B6FE33610BE17E87F10746A81AC95782F6D20EF22B19336E8E68128D93B2D8D1DA27CA82495B57FDB1EFA93FA174AEAFDB22DC54EB2098C5C2C72E69BE17066C819E6BFEFFFBA9F1794588F2024E66C641F0D0E6D0B98CF03CCE6233B52B30FBFD99F3FFDFC937B16D085F535A3FB68E834279323FB41A9F0D871A4FF0014C901C5BEE092CFD4C0E7D4410177868787BF3B47470E68085B6359967B1B318529C41FFA73CC990FA18A10B9E40110998EEB192F46B5AE100519221F46F65CF028FC86040C0709B16D9D108CB4221E90996D21C6B8424AAB797C2FC15382B3B917EA0144EE962168BA19221252F58F0BF2AE2B391C9A9538056306E5475271DA13F0E8636A1AA7CEFE2403DBB9E9B4F1CEB491D5D2AC3A36E0C81E734A8129DBAACB3A1E1361E85ACC3B48990EAC62EA20F704ED30E6EFC01A47444502460C22251039B06EA229C1FE5FB0BCE37F031BB18890B2725A3D3D5719D04337828720D4F21666A9CA17816D39553EA7CE98B3957892D55C30F571685B575A389A12C8F7BEB4724F71017F000381140437482910CC60406CBD86F49A2CEDBA2A36692250FB9B8E1CDBBA448B2FC0E6EA6164EB9FB6758E17106423A912F70CEB40D34C4A44B049CE49A41EB830BF5F48D40D92F21B17C10B893BA30893679735166076F924DFAF89FEBCC3C6A80D1F598F74216F81F2C77C374E392780586F9C1B2ED5667F2D63B84E11D76BA37DC2FDA87FB8675CFB786F9575871579FE107C8759E5F502667769A073E81925FB859DE1D887DC3EE4F607F98B66933F912C8EC9EDA09E27A918B74458874E66E4309C9CC6BEBA68CB30BAE449938C4C0D59D53901F540552B025D44154A2495D4202F169CF51099FDDA300ADB6E0031E9AF0D2049A46DE6CA0D53148B4E522D6655A5B3A2AC742F51186AB72C9599E988E52535E6F883D7BFFAA20986E3CB96222CD73697A473229A436DD66C4800E75848A5BD074D91719671401B6415375861DA4C546DA7EB074261F38CC1FC4E985656837594C286E77A5986225E21E4CA14C56783332EF31141A2E58C19731251B6EA9C5AC79DE7F332443ED81DA79CAFCB50E5F1BE68454A6E2216737D51D3CCDB844C277AD8AE486515EB15C3DDB18A4C5DD9CB7CB43B5276F32BE364634D14D7A93964DDEF9D86E3D7EE40F540EA14664536DC2ECEF2CCD93FD056B33E4FA4A5F7B332403AF4D6A3F5B57C779771F94A71901CE8DBC5407CF8F7F7FF76B6BDEFBFC7936A77115AA904CA609589371CAB8D8B739D24979E5FA06B176537BDB46E7EA469DC621312DBD2467AC481B9C17A4BA9800E0CC1C0FB878C098E0D9C115C2286672055D2DAB0878747C3DA43CF8FF3E8E24819906E2F2F2FDE9EC1C6A81B1B307D4BDD6AAF843D22E13F20F10B458B5FCB604FEB87EC00AEDEF3D80164A5AFB1155EA35110E84FB58B478829565BF6536377D9F1F3C3FBF0F94A1772BBFDFF71A3E7351C6A7701D2AF3DBF77CB37E3966F20A9EF22725A9AD14F81799EF0A937A29B8DCA4E9DE6758DE6E492A8F59D72AD7AA267D1A0EED8865EDB856E9350EA5F776852AFEC51B741A75DED27B6AF9BB76DD729FFE3943B0189E70584F9372A06BEB9C616A019CD059BF1CC4FF48ACA1A65243537BA0485B4E7A013A1F00CF94A4FFB2065FC9EF3159148939CD1290417EC3A5261A44EA4043A2595E73CD7592F3FEED1577576AF43F32577B104AD2636CE7FCD4E234C825CEFF316E75F0161DC3C4DD75A2B4F99B43D5FE648579C75044ACD3781109849F6774043A2C1E435F390C91BFD75BB97F005E6C85F6645D36A90CD1B5135BB3BC1682E10952946C1AF3FB50F0774F1E97F06F75DF03F280000, N'6.5.1')
GO
SET IDENTITY_INSERT [dbo].[Comments] ON 

INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (1, N'비밀번호: 1234', N'댓글테스트', N'R69Rvv7NhCcYIpeG76jyA6Y0UvIlluB5AAr9tLRnGsy+bC+ldfkLx+eQ7TIYh2hG', N'bfjntbiotmimfeoscds@google.com', CAST(N'2025-02-14T08:23:35.010' AS DateTime), 0, 4)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (2, N'페이징 용 댓글입니다.', N'김유신', N'commentpass1', N'kim@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (3, N'페이징 용 댓글입니다.', N'윤봉길', N'commentpass2', N'yoon@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (4, N'페이징 용 댓글입니다.', N'안중근', N'commentpass3', N'ahn@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (5, N'페이징 용 댓글입니다.', N'김유신', N'commentpass1', N'kim@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (6, N'페이징 용 댓글입니다.', N'윤봉길', N'commentpass2', N'yoon@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (7, N'페이징 용 댓글입니다.', N'안중근', N'commentpass3', N'ahn@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (8, N'페이징 용 댓글입니다.', N'김유신', N'commentpass1', N'kim@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (9, N'페이징 용 댓글입니다.', N'윤봉길', N'commentpass2', N'yoon@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (10, N'페이징 용 댓글입니다.', N'안중근', N'commentpass3', N'ahn@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (11, N'페이징 용 댓글입니다.', N'김유신', N'commentpass1', N'kim@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (12, N'페이징 용 댓글입니다.', N'윤봉길', N'commentpass2', N'yoon@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (13, N'페이징 용 댓글입니다.', N'안중근', N'commentpass3', N'ahn@example.com', CAST(N'2025-02-14T08:30:45.147' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (14, N'수정/삭제가 가능한 댓글입니다. 비밀번호는 1234', N'댓글테스트', N'5cXMYc5KnMP6FB2qemNEDBzqcvvSK+Ux0BurU8YeoU4S+TdJ3r+C/Zsi52h5oxyK', N'vmfdbmdfoibmfdoibmofdi@google.com', CAST(N'2025-02-14T08:32:10.550' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (15, N'페이징 용 댓글입니다.', N'김유신', N'commentpass1', N'kim@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (16, N'페이징 용 댓글입니다.', N'윤봉길', N'commentpass2', N'yoon@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (17, N'페이징 용 댓글입니다.', N'안중근', N'commentpass3', N'ahn@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (18, N'페이징 용 댓글입니다.', N'김유신', N'commentpass1', N'kim@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (19, N'페이징 용 댓글입니다.', N'윤봉길', N'commentpass2', N'yoon@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (20, N'페이징 용 댓글입니다.', N'안중근', N'commentpass3', N'ahn@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (21, N'페이징 용 댓글입니다.', N'김유신', N'commentpass1', N'kim@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (22, N'페이징 용 댓글입니다.', N'윤봉길', N'commentpass2', N'yoon@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (23, N'페이징 용 댓글입니다.', N'안중근', N'commentpass3', N'ahn@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (24, N'페이징 용 댓글입니다.', N'김유신', N'commentpass1', N'kim@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (25, N'페이징 용 댓글입니다.', N'윤봉길', N'commentpass2', N'yoon@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (26, N'페이징 용 댓글입니다.', N'안중근', N'commentpass3', N'ahn@example.com', CAST(N'2025-02-14T08:36:47.650' AS DateTime), 0, 17)
INSERT [dbo].[Comments] ([Id], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [CreatedAt], [IsRemove], [PostId]) VALUES (27, N'수정/삭제가 가능한 댓글입니다.
비밀번호는 1234', N'댓글 테스트', N'iX2V3cdUirpD9WvpBXde+6xyjF9rmUTb9sPppO4Um4J5Idn4QRvcTVzc3ZYt/K25', N'dsbtrhtrgrgre4t@naver.com', CAST(N'2025-02-14T08:37:27.287' AS DateTime), 0, 17)
SET IDENTITY_INSERT [dbo].[Comments] OFF
GO
SET IDENTITY_INSERT [dbo].[Documents] ON 

INSERT [dbo].[Documents] ([Id], [Title], [Content], [AuthorName], [IsRemove], [PostId], [CreatedAt]) VALUES (1, NULL, NULL, N'신도영', 0, 4, CAST(N'2025-02-14T08:23:14.340' AS DateTime))
INSERT [dbo].[Documents] ([Id], [Title], [Content], [AuthorName], [IsRemove], [PostId], [CreatedAt]) VALUES (2, NULL, NULL, N'신도영', 0, 17, CAST(N'2025-02-14T08:26:45.813' AS DateTime))
SET IDENTITY_INSERT [dbo].[Documents] OFF
GO
SET IDENTITY_INSERT [dbo].[Posts] ON 

INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (4, N'1번째 게시물입니다.', N'&lt;h1 style=&quot;text-align:center;&quot; data-placeholder=&quot;내용을 입력해주세요.&quot;&gt;&lt;strong&gt;제목1&lt;/strong&gt;&lt;/h1&gt;&lt;p style=&quot;text-align:center;&quot;&gt;&lt;strong&gt;내용&lt;/strong&gt;&lt;/p&gt;&lt;p style=&quot;text-align:center;&quot;&gt;&lt;strong&gt;비밀번호: 1234&lt;/strong&gt;&lt;/p&gt;', N'신도영', N'WnLHkJXYyGdZZC9urIaGEDL5qykEW7j8vA2Ptzg3lR6B/A2pSuUs2FiVyH6LOxmL', N'njyyujtfgttervfgng@google.com', 0, 0, CAST(N'2025-02-14T08:23:14.047' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (5, N'4 번째 게시글', N'4 번째 게시글의 내용입니다. &lt;b&gt;굵은 글씨&lt;/b&gt;', N'홍길동', N'password123', N'hong@example.com', 0, 0, CAST(N'2025-02-14T08:24:18.017' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (6, N'5 번째 게시글', N'5 번째 게시글의 내용입니다. &lt;i&gt;기울임 글씨&lt;/i&gt;', N'이순신', N'password456', N'lee@example.com', 0, 0, CAST(N'2025-02-14T08:24:18.017' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (7, N'6 번째 게시글', N'6 번째 게시글의 내용입니다. &lt;u&gt;밑줄 글씨&lt;/u&gt;', N'강감찬', N'password789', N'kang@example.com', 0, 0, CAST(N'2025-02-14T08:24:18.017' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (8, N'7 번째 게시글', N'7 번째 게시글의 내용입니다. &lt;b&gt;굵은 글씨&lt;/b&gt;', N'홍길동', N'password123', N'hong@example.com', 0, 0, CAST(N'2025-02-14T08:24:27.847' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (9, N'8 번째 게시글', N'8 번째 게시글의 내용입니다. &lt;i&gt;기울임 글씨&lt;/i&gt;', N'이순신', N'password456', N'lee@example.com', 0, 0, CAST(N'2025-02-14T08:24:27.847' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (10, N'9 번째 게시글', N'9 번째 게시글의 내용입니다. &lt;u&gt;밑줄 글씨&lt;/u&gt;', N'강감찬', N'password789', N'kang@example.com', 0, 0, CAST(N'2025-02-14T08:24:27.847' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (11, N'10 번째 게시글', N'10 번째 게시글의 내용입니다. &lt;b&gt;굵은 글씨&lt;/b&gt;', N'홍길동', N'password123', N'hong@example.com', 0, 0, CAST(N'2025-02-14T08:24:38.233' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (12, N'11 번째 게시글', N'11 번째 게시글의 내용입니다. &lt;i&gt;기울임 글씨&lt;/i&gt;', N'이순신', N'password456', N'lee@example.com', 0, 0, CAST(N'2025-02-14T08:24:38.233' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (13, N'12 번째 게시글', N'12 번째 게시글의 내용입니다. &lt;u&gt;밑줄 글씨&lt;/u&gt;', N'강감찬', N'password789', N'kang@example.com', 0, 0, CAST(N'2025-02-14T08:24:38.233' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (14, N'13 번째 게시글', N'13 번째 게시글의 내용입니다. &lt;b&gt;굵은 글씨&lt;/b&gt;', N'홍길동', N'password123', N'hong@example.com', 0, 0, CAST(N'2025-02-14T08:24:48.750' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (15, N'14 번째 게시글', N'14 번째 게시글의 내용입니다. &lt;i&gt;기울임 글씨&lt;/i&gt;', N'이순신', N'password456', N'lee@example.com', 0, 0, CAST(N'2025-02-14T08:24:48.750' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (16, N'15 번째 게시글', N'15 번째 게시글의 내용입니다. &lt;u&gt;밑줄 글씨&lt;/u&gt;', N'강감찬', N'password789', N'kang@example.com', 0, 1, CAST(N'2025-02-14T08:24:48.750' AS DateTime))
INSERT [dbo].[Posts] ([Id], [Title], [Content], [AuthorName], [AuthorPassword], [AuthorEmail], [IsRemove], [HasDocument], [CreatedAt]) VALUES (17, N'수정/삭제가 가능한 게시글', N'&lt;h1 style=&quot;text-align:center;&quot; data-placeholder=&quot;내용을 입력해주세요.&quot;&gt;수정, 삭제가 가능한 게시글입니다.&lt;/h1&gt;&lt;p class=&quot;info-box&quot; style=&quot;text-align:center;&quot;&gt;비밀번호는 1234&lt;/p&gt;', N'신도영', N's1F5Xkf/15zD+2PoyV9K8rPxDnM0m3nTvUP0iIfcD37P3W3rwfIUcIOOFMjdHTCx', N'straipe@naver.com', 0, 1, CAST(N'2025-02-14T08:26:45.807' AS DateTime))
SET IDENTITY_INSERT [dbo].[Posts] OFF
GO
