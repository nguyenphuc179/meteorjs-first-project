USE [master]
GO
/****** Object:  Database [CTGroupBO]    Script Date: 12/7/2016 5:15:53 PM ******/
CREATE DATABASE [CTGroupBO] ON  PRIMARY 
( NAME = N'CTGroupBO', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\CTGroupBO.mdf' , SIZE = 163840KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CTGroupBO_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\CTGroupBO_log.ldf' , SIZE = 388544KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [CTGroupBO] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CTGroupBO].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CTGroupBO] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CTGroupBO] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CTGroupBO] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CTGroupBO] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CTGroupBO] SET ARITHABORT OFF 
GO
ALTER DATABASE [CTGroupBO] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CTGroupBO] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [CTGroupBO] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CTGroupBO] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CTGroupBO] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CTGroupBO] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CTGroupBO] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CTGroupBO] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CTGroupBO] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CTGroupBO] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CTGroupBO] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CTGroupBO] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CTGroupBO] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CTGroupBO] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CTGroupBO] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CTGroupBO] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CTGroupBO] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CTGroupBO] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CTGroupBO] SET RECOVERY FULL 
GO
ALTER DATABASE [CTGroupBO] SET  MULTI_USER 
GO
ALTER DATABASE [CTGroupBO] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CTGroupBO] SET DB_CHAINING OFF 
GO
EXEC sys.sp_db_vardecimal_storage_format N'CTGroupBO', N'ON'
GO
USE [CTGroupBO]
GO
/****** Object:  StoredProcedure [dbo].[CategoryTree]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CategoryTree]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	WITH
  cteReports (Id, ten_chung_loai, rootName, pathSort, parentId, level)
  AS
  (
    SELECT Id, ten_chung_loai, ten_chung_loai, RIGHT('000000' + CAST(id AS varchar(MAX)), 6), cls_cha, 1
    FROM Category_Project_CTGroup
    WHERE cls_cha IS NULL OR cls_cha = 0

    UNION ALL

    SELECT c.Id, c.ten_chung_loai, r.rootName, r.pathSort + RIGHT('000000' + CAST(c.id AS varchar(MAX)), 6),  c.cls_cha, r.level + 1
    FROM Category_Project_CTGroup c
      INNER JOIN cteReports r
        ON c.cls_cha = r.Id
  )
SELECT
  Id, ten_chung_loai, rootName, pathSort, parentId, [level]
FROM cteReports
order by pathSort
END

GO
/****** Object:  StoredProcedure [dbo].[spCreateHrLeaveRecord]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spCreateHrLeaveRecord]
	@Id INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE	@return_value int,
		@Result nvarchar(2000)
	DECLARE	@EmpID NVARCHAR
	SET @EmpID = ' '
	EXEC	@return_value = HRM.SVHRISCTG.[dbo].[TS_spfrmLeaveRecord]
			@EmpID = @EmpID,
			@Total = 1,
			@Result = @Result OUTPUT

	SELECT	@Result as N'@Result'

	SELECT	'Return Value' = @return_value
END

GO
/****** Object:  StoredProcedure [dbo].[spJobSyncEmp]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spJobSyncEmp]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
    UPDATE u
	SET u.ManagerId = (SELECT TOP 1 u2.Id
						 FROM [User] u2 WHERE u2.EmployeeId  = ISNULL(l3.EmpHeadID, l2.EmpHeadID))
	FROM [User] u JOIN HRM.SVHRISCTG.dbo.HR_tblEmp hr ON u.EmployeeId = hr.EmpId
		 LEFT JOIN HRM.SVHRISCTG.dbo.LS_tblLevel2 l2 ON hr.LSLevel2ID = l2.LSLevel2ID
		 LEFT JOIN HRM.SVHRISCTG.dbo.LS_tblLevel3 l3 ON hr.LSLevel3ID = l3.LSLevel3ID
	WHERE (u.ManagerId IS NULL OR u.ManagerId <>  ISNULL(l3.EmpHeadID, l2.EmpHeadID)) AND (l2.EmpHeadID IS NOT NULL OR l3.EmpHeadID IS NOT NULL)
END

GO
/****** Object:  StoredProcedure [dbo].[spJobSyncLeaveRecord]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spJobSyncLeaveRecord]
	
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO LeaveRecord
(
	-- Id -- this column value is auto-generated
	UserId,
	FromDate,
	FromTime,
	ToDate,
	ToTime,
	TotalLeave,
	LeaveType,
	Reason,
	[Status],
	CreatedTime,
	HrId
)
	SELECT u.Id, 
		l.FromDate, 
		CASE WHEN ld1.[LeaveTakenName] = 'S' THEN dbo.LeaveTime_Morning()
		     WHEN ld1.[LeaveTakenName] = 'C' THEN dbo.LeaveTime_Afternoon()
		     ELSE dbo.LeaveTime_Morning() END,
		
		l.ToDate, 
		CASE WHEN ld2.[LeaveTakenName] = 'S' THEN dbo.LeaveTime_Morning()
		     WHEN ld2.[LeaveTakenName] = 'C' THEN dbo.LeaveTime_Afternoon()
		     ELSE dbo.LeaveTime_Afternoon() END, 
		l.Total, 
		lt.Id, 
		ISNULL(l.Note, ''), 
		dbo.LeaveRecordStatus_Approved(), 
		l.CreateTime, 
		l.LeaveRecordId
		
		
    FROM HRM.SVHRISCTG.dbo.TS_tblLeaveRecord l
		JOIN [User] u ON l.EmpID = u.EmployeeId
		JOIN WorkLeaveType lt ON l.LSWorkPointID = lt.Code
		JOIN HRM.SVHRISCTG.dbo.TS_tblLeaveRecordDetail ld1 ON l.[LeaveRecordID] = ld1.[LeaveRecordID] AND l.FromDate = ld1.DateID
		JOIN HRM.SVHRISCTG.dbo.TS_tblLeaveRecordDetail ld2 ON l.[LeaveRecordID] = ld2.[LeaveRecordID] AND l.ToDate = ld2.DateID
	WHERE [LSApprovalStatusID] = 'HRConfirm' AND NOT EXISTS(SELECT * FROM LeaveRecord AS lr WHERE lr.HrId = l.LeaveRecordId)
	
	-- xoa record bi xoa tu HR
	
	DELETE FROM LeaveRecord
	WHERE HrId IS NOT NULL AND NOT EXISTS (SELECT * FROM HRM.SVHRISCTG.dbo.TS_tblLeaveRecord l WHERE l.LeaveRecordID = HrId)
END

GO
/****** Object:  StoredProcedure [dbo].[spJobUnbookProduct]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spJobUnbookProduct]
	
AS
BEGIN
	SET NOCOUNT ON;
	Update Product set status = dbo.ProductStatus_ChaoBan() where status = dbo.ProductStatus_GiuCho() and BookTime < DATEADD(d, -1, GETDATE())
END

GO
/****** Object:  UserDefinedFunction [dbo].[AreaType_HoanThien]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[AreaType_HoanThien]() RETURNS INT AS
BEGIN RETURN 2 END

GO
/****** Object:  UserDefinedFunction [dbo].[AreaType_Tho]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[AreaType_Tho]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  UserDefinedFunction [dbo].[AreaType_ThongThuy]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[AreaType_ThongThuy]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[CustomerContractStatus_ChuaKy]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CustomerContractStatus_ChuaKy]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  UserDefinedFunction [dbo].[CustomerContractStatus_DaKy]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CustomerContractStatus_DaKy]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[CustomerContractType_BanCanHo]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CustomerContractType_BanCanHo]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[CustomerType_Company]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CustomerType_Company]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[CustomerType_Person]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CustomerType_Person]() RETURNS INT AS
BEGIN RETURN 2 END

GO
/****** Object:  UserDefinedFunction [dbo].[CustomerType_Supplier]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CustomerType_Supplier]() RETURNS INT AS
BEGIN RETURN 3 END

GO
/****** Object:  UserDefinedFunction [dbo].[EmployeeStatus_DangLam]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[EmployeeStatus_DangLam]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[EmployeeStatus_NghiViec]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[EmployeeStatus_NghiViec]() RETURNS INT AS
BEGIN RETURN 2 END

GO
/****** Object:  UserDefinedFunction [dbo].[FamilySizeCustomer_People3to5]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FamilySizeCustomer_People3to5]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[FamilySizeCustomer_PeopleThan5]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FamilySizeCustomer_PeopleThan5]() RETURNS INT AS
BEGIN RETURN 2 END

GO
/****** Object:  UserDefinedFunction [dbo].[FamilySizeCustomer_Single]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FamilySizeCustomer_Single]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  UserDefinedFunction [dbo].[ForgetCheckTimeStatus_ChapNhan]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ForgetCheckTimeStatus_ChapNhan]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[ForgetCheckTimeStatus_KhongChapNhan]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ForgetCheckTimeStatus_KhongChapNhan]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  UserDefinedFunction [dbo].[Gender_Female]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Gender_Female]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[Gender_Male]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Gender_Male]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  UserDefinedFunction [dbo].[LeaveRecordStatus_Approved]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LeaveRecordStatus_Approved]() RETURNS INT AS
BEGIN RETURN 2 END

GO
/****** Object:  UserDefinedFunction [dbo].[LeaveRecordStatus_Deleted]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LeaveRecordStatus_Deleted]() RETURNS INT AS
BEGIN RETURN 4 END

GO
/****** Object:  UserDefinedFunction [dbo].[LeaveRecordStatus_Pending]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LeaveRecordStatus_Pending]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[LeaveRecordStatus_Rejected]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LeaveRecordStatus_Rejected]() RETURNS INT AS
BEGIN RETURN 3 END

GO
/****** Object:  UserDefinedFunction [dbo].[LeaveTime_Afternoon]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LeaveTime_Afternoon]() RETURNS INT AS
BEGIN RETURN 2 END

GO
/****** Object:  UserDefinedFunction [dbo].[LeaveTime_Morning]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LeaveTime_Morning]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_ContractCommission_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_ContractCommission_Create]() RETURNS INT AS
BEGIN RETURN 4000 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_ContractCommission_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_ContractCommission_Edit]() RETURNS INT AS
BEGIN RETURN 4001 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_ContractTemplate_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_ContractTemplate_Create]() RETURNS INT AS
BEGIN RETURN 2006 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_ContractTemplate_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_ContractTemplate_Edit]() RETURNS INT AS
BEGIN RETURN 2007 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_Customer_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_Customer_Create]() RETURNS INT AS
BEGIN RETURN 3000 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_Customer_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_Customer_Edit]() RETURNS INT AS
BEGIN RETURN 3001 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_CustomerContract_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_CustomerContract_Create]() RETURNS INT AS
BEGIN RETURN 4002 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_CustomerContract_CreatePaymentProcess]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_CustomerContract_CreatePaymentProcess]() RETURNS INT AS
BEGIN RETURN 4004 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_CustomerContract_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_CustomerContract_Edit]() RETURNS INT AS
BEGIN RETURN 4003 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_CustomerContract_EditPaymentProcess]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_CustomerContract_EditPaymentProcess]() RETURNS INT AS
BEGIN RETURN 4005 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_CustomerContract_UploadFile]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_CustomerContract_UploadFile]() RETURNS INT AS
BEGIN RETURN 4006 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_Product_AssignSale]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_Product_AssignSale]() RETURNS INT AS
BEGIN RETURN 2008 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_Product_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_Product_Create]() RETURNS INT AS
BEGIN RETURN 2000 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_Product_CreateProcessProject]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_Product_CreateProcessProject]() RETURNS INT AS
BEGIN RETURN 2004 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_Product_CreateProject]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_Product_CreateProject]() RETURNS INT AS
BEGIN RETURN 2002 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_Product_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_Product_Edit]() RETURNS INT AS
BEGIN RETURN 2001 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_Product_EditProcessProject]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_Product_EditProcessProject]() RETURNS INT AS
BEGIN RETURN 2005 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_Product_EditProject]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_Product_EditProject]() RETURNS INT AS
BEGIN RETURN 2003 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_User_Block]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_User_Block]() RETURNS INT AS
BEGIN RETURN 1003 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_User_CreatePositionCode]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_User_CreatePositionCode]() RETURNS INT AS
BEGIN RETURN 1006 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_User_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_User_Edit]() RETURNS INT AS
BEGIN RETURN 1001 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_User_EditPositionCode]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_User_EditPositionCode]() RETURNS INT AS
BEGIN RETURN 1005 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_User_LeaveRecord_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_User_LeaveRecord_Create]() RETURNS INT AS
BEGIN RETURN 1007 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_User_LeaveRecord_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_User_LeaveRecord_Edit]() RETURNS INT AS
BEGIN RETURN 1008 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_User_Login]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_User_Login]() RETURNS INT AS
BEGIN RETURN 1000 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_User_SyncHr]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_User_SyncHr]() RETURNS INT AS
BEGIN RETURN 1002 END

GO
/****** Object:  UserDefinedFunction [dbo].[LogType_User_Unblock]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[LogType_User_Unblock]() RETURNS INT AS
BEGIN RETURN 1004 END

GO
/****** Object:  UserDefinedFunction [dbo].[MaritalStatusCustomer_Married]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[MaritalStatusCustomer_Married]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[MaritalStatusCustomer_Single]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[MaritalStatusCustomer_Single]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  UserDefinedFunction [dbo].[PaymentProcessType_TheoCamKetKhachHang]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PaymentProcessType_TheoCamKetKhachHang]() RETURNS INT AS
BEGIN RETURN 2 END

GO
/****** Object:  UserDefinedFunction [dbo].[PaymentProcessType_TheoTienDoXayDung]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PaymentProcessType_TheoTienDoXayDung]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_AssignProject_Assgin]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_AssignProject_Assgin]() RETURNS INT AS
BEGIN RETURN 4007 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_ContractComission_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_ContractComission_Edit]() RETURNS INT AS
BEGIN RETURN 5008 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_ContractCommision_View]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_ContractCommision_View]() RETURNS INT AS
BEGIN RETURN 5007 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_ContractCustomer_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_ContractCustomer_Create]() RETURNS INT AS
BEGIN RETURN 5004 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_ContractCustomer_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_ContractCustomer_Edit]() RETURNS INT AS
BEGIN RETURN 5006 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_ContractCustomer_View]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_ContractCustomer_View]() RETURNS INT AS
BEGIN RETURN 5005 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_ContractTemplate_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_ContractTemplate_Create]() RETURNS INT AS
BEGIN RETURN 5001 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_ContractTemplate_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_ContractTemplate_Edit]() RETURNS INT AS
BEGIN RETURN 5003 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_ContractTemplate_View]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_ContractTemplate_View]() RETURNS INT AS
BEGIN RETURN 5002 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Customer_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Customer_Create]() RETURNS INT AS
BEGIN RETURN 2002 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Customer_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Customer_Edit]() RETURNS INT AS
BEGIN RETURN 2004 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Customer_ImportCustomer]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Customer_ImportCustomer]() RETURNS INT AS
BEGIN RETURN 2005 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Customer_SubmissionFileCreate]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Customer_SubmissionFileCreate]() RETURNS INT AS
BEGIN RETURN 2008 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Customer_SubmissionFileView]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Customer_SubmissionFileView]() RETURNS INT AS
BEGIN RETURN 2007 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Customer_View]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Customer_View]() RETURNS INT AS
BEGIN RETURN 2003 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Customer_ViewAll]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Customer_ViewAll]() RETURNS INT AS
BEGIN RETURN 2006 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Deploy_Note]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Deploy_Note]() RETURNS INT AS
BEGIN RETURN 4008 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_ProcessProject_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_ProcessProject_Create]() RETURNS INT AS
BEGIN RETURN 4004 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_ProcessProject_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_ProcessProject_Edit]() RETURNS INT AS
BEGIN RETURN 4006 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Product_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Product_Create]() RETURNS INT AS
BEGIN RETURN 3002 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Product_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Product_Edit]() RETURNS INT AS
BEGIN RETURN 3004 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Product_FullControl]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Product_FullControl]() RETURNS INT AS
BEGIN RETURN 3008 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Product_ImportExcel]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Product_ImportExcel]() RETURNS INT AS
BEGIN RETURN 3005 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Product_SaleGiuCho]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Product_SaleGiuCho]() RETURNS INT AS
BEGIN RETURN 3007 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Product_View]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Product_View]() RETURNS INT AS
BEGIN RETURN 3003 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Product_ViewStackPlan]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Product_ViewStackPlan]() RETURNS INT AS
BEGIN RETURN 3006 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Project_Create]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Project_Create]() RETURNS INT AS
BEGIN RETURN 4001 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Project_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Project_Edit]() RETURNS INT AS
BEGIN RETURN 4003 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Project_View]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Project_View]() RETURNS INT AS
BEGIN RETURN 4002 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Report_ChiTietThuChi]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Report_ChiTietThuChi]() RETURNS INT AS
BEGIN RETURN 6005 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Report_KeToanChiTietTaiKhoan]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Report_KeToanChiTietTaiKhoan]() RETURNS INT AS
BEGIN RETURN 6002 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Report_NhanSu]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Report_NhanSu]() RETURNS INT AS
BEGIN RETURN 6001 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Report_TongHopNganQuy]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Report_TongHopNganQuy]() RETURNS INT AS
BEGIN RETURN 6003 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Report_TongThuChi]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Report_TongThuChi]() RETURNS INT AS
BEGIN RETURN 6004 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_Report_TuyenDung]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_Report_TuyenDung]() RETURNS INT AS
BEGIN RETURN 6000 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_Add_Group]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_Add_Group]() RETURNS INT AS
BEGIN RETURN 1006 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_Add_Permission_Group]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_Add_Permission_Group]() RETURNS INT AS
BEGIN RETURN 1011 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_AddPermission]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_AddPermission]() RETURNS INT AS
BEGIN RETURN 1005 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_Block]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_Block]() RETURNS INT AS
BEGIN RETURN 1012 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_Create_Group]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_Create_Group]() RETURNS INT AS
BEGIN RETURN 1008 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_Edit]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_Edit]() RETURNS INT AS
BEGIN RETURN 1004 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_Edit_Group]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_Edit_Group]() RETURNS INT AS
BEGIN RETURN 1010 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_ManageForgetCheckTime]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_ManageForgetCheckTime]() RETURNS INT AS
BEGIN RETURN 1020 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_ManageLeaveRecord]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_ManageLeaveRecord]() RETURNS INT AS
BEGIN RETURN 1019 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_SyncHrEmployee]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_SyncHrEmployee]() RETURNS INT AS
BEGIN RETURN 1007 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_View]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_View]() RETURNS INT AS
BEGIN RETURN 1003 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_View_Group]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_View_Group]() RETURNS INT AS
BEGIN RETURN 1009 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_ViewAll]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_ViewAll]() RETURNS INT AS
BEGIN RETURN 1017 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_ViewAllTimeLog]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_ViewAllTimeLog]() RETURNS INT AS
BEGIN RETURN 1018 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_ViewHistoryCall]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_ViewHistoryCall]() RETURNS INT AS
BEGIN RETURN 1015 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_ViewHistoryCallAll]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_ViewHistoryCallAll]() RETURNS INT AS
BEGIN RETURN 1016 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_ViewStorage]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_ViewStorage]() RETURNS INT AS
BEGIN RETURN 1014 END

GO
/****** Object:  UserDefinedFunction [dbo].[Permission_User_ViewTimeLog]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Permission_User_ViewTimeLog]() RETURNS INT AS
BEGIN RETURN 1013 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductMoney_USD]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductMoney_USD]() RETURNS INT AS
BEGIN RETURN 2 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductMoney_VND]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductMoney_VND]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductPosition_Bac]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductPosition_Bac]() RETURNS INT AS
BEGIN RETURN 4 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductPosition_Dong]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductPosition_Dong]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductPosition_Dong_Bac]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductPosition_Dong_Bac]() RETURNS INT AS
BEGIN RETURN 5 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductPosition_Dong_Nam]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductPosition_Dong_Nam]() RETURNS INT AS
BEGIN RETURN 6 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductPosition_Nam]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductPosition_Nam]() RETURNS INT AS
BEGIN RETURN 3 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductPosition_Tay]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductPosition_Tay]() RETURNS INT AS
BEGIN RETURN 2 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductPosition_Tay_Bac]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductPosition_Tay_Bac]() RETURNS INT AS
BEGIN RETURN 8 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductPosition_Tay_Nam]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductPosition_Tay_Nam]() RETURNS INT AS
BEGIN RETURN 7 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductStatus_ChaoBan]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductStatus_ChaoBan]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductStatus_DaHopDong]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductStatus_DaHopDong]() RETURNS INT AS
BEGIN RETURN 3 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductStatus_DatCoc]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductStatus_DatCoc]() RETURNS INT AS
BEGIN RETURN 2 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductStatus_GiuCho]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductStatus_GiuCho]() RETURNS INT AS
BEGIN RETURN 4 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductStatus_KhongBan]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductStatus_KhongBan]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductUnit_Bo]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductUnit_Bo]() RETURNS INT AS
BEGIN RETURN 10 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductUnit_Cai]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductUnit_Cai]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductUnit_Chiec]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductUnit_Chiec]() RETURNS INT AS
BEGIN RETURN 11 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductUnit_Con]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductUnit_Con]() RETURNS INT AS
BEGIN RETURN 15 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductUnit_Goi]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductUnit_Goi]() RETURNS INT AS
BEGIN RETURN 20 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductUnit_Hop]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductUnit_Hop]() RETURNS INT AS
BEGIN RETURN 3 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductUnit_Kg]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductUnit_Kg]() RETURNS INT AS
BEGIN RETURN 14 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductUnit_Nguoi_Dung]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductUnit_Nguoi_Dung]() RETURNS INT AS
BEGIN RETURN 21 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductUnit_Thung]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductUnit_Thung]() RETURNS INT AS
BEGIN RETURN 16 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductView_DB]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductView_DB]() RETURNS INT AS
BEGIN RETURN 4 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductView_DB_TB]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductView_DB_TB]() RETURNS INT AS
BEGIN RETURN 8 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductView_DN]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductView_DN]() RETURNS INT AS
BEGIN RETURN 5 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductView_DN_DB]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductView_DN_DB]() RETURNS INT AS
BEGIN RETURN 2 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductView_TB]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductView_TB]() RETURNS INT AS
BEGIN RETURN 3 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductView_TB_DB]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductView_TB_DB]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductView_TN]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductView_TN]() RETURNS INT AS
BEGIN RETURN 6 END

GO
/****** Object:  UserDefinedFunction [dbo].[ProductView_TN_DN]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ProductView_TN_DN]() RETURNS INT AS
BEGIN RETURN 7 END

GO
/****** Object:  UserDefinedFunction [dbo].[RankingResultStatus_Approved]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[RankingResultStatus_Approved]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[RankingResultStatus_Pending]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[RankingResultStatus_Pending]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  UserDefinedFunction [dbo].[StatusApprove_Approved]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[StatusApprove_Approved]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[StatusApprove_Pending]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[StatusApprove_Pending]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  UserDefinedFunction [dbo].[StatusCustomer_NotWork]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[StatusCustomer_NotWork]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  UserDefinedFunction [dbo].[StatusCustomer_Working]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[StatusCustomer_Working]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[TypeCustomer_CTGroup]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TypeCustomer_CTGroup]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  UserDefinedFunction [dbo].[TypeCustomer_DirectCustomer]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TypeCustomer_DirectCustomer]() RETURNS INT AS
BEGIN RETURN 1 END

GO
/****** Object:  UserDefinedFunction [dbo].[TypeInputCustomer_Import]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TypeInputCustomer_Import]() RETURNS INT AS
BEGIN RETURN 1 END 
GO
/****** Object:  UserDefinedFunction [dbo].[TypeInputCustomer_Input]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TypeInputCustomer_Input]() RETURNS INT AS
BEGIN RETURN 0 END

GO
/****** Object:  Table [dbo].[ActivityLog]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ActivityLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ActivityLogType] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[RawData] [ntext] NULL,
	[UserId] [int] NULL,
	[RowId] [varchar](50) NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ActivityLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ApartmentDetails]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApartmentDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NULL,
	[Width] [decimal](10, 1) NULL,
	[Longs] [decimal](10, 1) NULL,
	[Height] [decimal](10, 1) NULL,
	[Bedroom1] [decimal](10, 1) NULL,
	[Bedroom2] [decimal](10, 1) NULL,
	[Bedroom3] [decimal](10, 1) NULL,
	[Bedroom4] [decimal](10, 1) NULL,
	[Bathroom1] [decimal](10, 1) NULL,
	[Bathroom2] [decimal](10, 1) NULL,
	[Bathroom3] [decimal](10, 1) NULL,
	[Bathroom4] [decimal](10, 1) NULL,
	[LivingRoom1] [decimal](10, 1) NULL,
	[LivingRoom2] [decimal](10, 1) NULL,
	[Kitchen] [decimal](10, 1) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApproveAutoConfig]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApproveAutoConfig](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentID] [varchar](50) NULL,
	[UserID] [int] NULL,
	[LevelType] [int] NULL,
	[Status] [int] NULL,
	[TimeCreated] [datetime] NULL,
	[UserCreated] [int] NULL,
	[FileTypeID] [int] NOT NULL,
	[SubLevelType] [int] NOT NULL,
 CONSTRAINT [PK_ApproveAutoConfig] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ApproveGroup]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApproveGroup](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](2000) NOT NULL,
	[ShortName] [nvarchar](2000) NULL,
	[Description] [nvarchar](2000) NULL,
	[UserCreated] [int] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[Status] [int] NOT NULL,
	[DepartmentID] [varchar](50) NULL,
 CONSTRAINT [PK_ApproveGroup] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ApproveGroupUser]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApproveGroupUser](
	[ApproveGroupID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[UserCreated] [int] NOT NULL,
 CONSTRAINT [PK_ApproveGroupUser] PRIMARY KEY CLUSTERED 
(
	[ApproveGroupID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApproveTransaction]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ApproveTransaction](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[FileTypeID] [int] NOT NULL,
	[RefID] [bigint] NOT NULL,
	[NextApprove] [int] NULL,
	[HistoryLog] [nvarchar](max) NULL,
	[Status] [int] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[UserCreated] [int] NOT NULL,
	[DepartmentID] [varchar](50) NULL,
	[NextTimeApprove] [datetime] NULL,
	[TimeApprove] [datetime] NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_ApproveTransaction] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ApproveTransactionHistory]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApproveTransactionHistory](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserApproved] [int] NOT NULL,
	[TimeApproved] [datetime] NULL,
	[ApproveTransactionID] [bigint] NOT NULL,
	[Note] [nvarchar](max) NULL,
	[Status] [int] NOT NULL,
 CONSTRAINT [PK_ApproveTransactionHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bank]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bank](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](2000) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_Bank] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BankBranch]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankBranch](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](2000) NOT NULL,
	[BankID] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_BankBranch] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Block]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Block](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BlockName] [nvarchar](500) NULL,
	[ProjectId] [int] NULL,
	[So_tang] [int] NULL,
	[So_tang_ham] [int] NULL,
	[Status] [int] NULL,
	[Description] [nvarchar](4000) NULL,
 CONSTRAINT [PK_Block] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CallLog]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CallLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CallTimeStart] [datetime] NULL,
	[Clid] [nvarchar](100) NULL,
	[Src] [nvarchar](100) NULL,
	[Dst] [nvarchar](100) NULL,
	[Duration] [int] NULL,
	[BillSec] [int] NULL,
	[Disposition] [nvarchar](100) NULL,
	[LastApp] [nvarchar](100) NULL,
	[CustomerId] [int] NULL,
	[Note] [nvarchar](max) NULL,
	[Type] [int] NOT NULL,
	[IsImport] [bit] NOT NULL,
 CONSTRAINT [PK_CallCenter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Candidate]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Candidate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NULL,
	[DateOfBirth] [datetime] NULL,
	[Gender] [int] NULL,
	[Phone] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[Address] [nvarchar](500) NULL,
	[CountryId] [int] NULL,
	[CityId] [int] NULL,
	[DistrictId] [int] NULL,
	[WardId] [int] NULL,
	[CMND] [nvarchar](50) NULL,
	[JobTitle] [nvarchar](100) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[Note] [nvarchar](max) NULL,
 CONSTRAINT [PK_Candidate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CandidateCareer]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CandidateCareer](
	[CandidateId] [int] NOT NULL,
	[CareerId] [int] NOT NULL,
	[TimeCreate] [datetime] NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_CandidateCareer] PRIMARY KEY CLUSTERED 
(
	[CandidateId] ASC,
	[CareerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Career]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Career](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Status] [bit] NOT NULL,
 CONSTRAINT [PK_Career] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[City]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[ID] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Type] [nvarchar](20) NULL,
	[NationId] [int] NULL,
 CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CommonQuestion]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommonQuestion](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](200) NOT NULL,
	[Status] [bit] NOT NULL,
 CONSTRAINT [PK_CommonQuestion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CommonQuestion_CallLog]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommonQuestion_CallLog](
	[CommonQuestionId] [int] NOT NULL,
	[CallLogId] [bigint] NOT NULL,
	[TimeCreate] [datetime] NOT NULL,
 CONSTRAINT [PK_CommonQuestion_CallLog] PRIMARY KEY CLUSTERED 
(
	[CommonQuestionId] ASC,
	[CallLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Company]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Company](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](2000) NOT NULL,
	[Address] [nvarchar](2000) NOT NULL,
	[TaxCode] [varchar](500) NULL,
	[Represent] [nvarchar](500) NULL,
	[Logo] [varchar](500) NULL,
	[TimeCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContractCommission]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractCommission](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NULL,
	[ContractId] [int] NULL,
	[Percentage] [int] NULL,
	[PaymentDate] [date] NULL,
	[PaymentAmount] [decimal](14, 2) NULL,
	[PaidAmount] [decimal](14, 2) NULL,
	[SaleCommission] [decimal](4, 2) NULL,
	[SupportCommission] [decimal](4, 2) NULL,
 CONSTRAINT [PK_ContractCommission] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ContractFile]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContractFile](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ContractId] [int] NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[FileContent] [varbinary](max) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_ContractFile] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContractTemplate]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[ProjectId] [int] NULL,
	[CreateDate] [date] NULL,
	[File] [ntext] NULL,
	[Description] [nvarchar](255) NULL,
 CONSTRAINT [PK_ContractTemplate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NULL,
	[DateOfBirth] [date] NULL,
	[Gender] [int] NULL,
	[Phone] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Address] [nvarchar](500) NULL,
	[CountryId] [int] NULL,
	[CityId] [int] NULL,
	[DistrictId] [int] NULL,
	[WardId] [int] NULL,
	[Company] [nvarchar](500) NULL,
	[CMND] [nvarchar](50) NULL,
	[MST] [nvarchar](50) NULL,
	[JobTitle] [nvarchar](100) NULL,
	[Website] [nvarchar](100) NULL,
	[Fax] [nvarchar](50) NULL,
	[IsCompany] [bit] NOT NULL,
	[IsPerson] [bit] NOT NULL,
	[IsSupplier] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[SaleId] [int] NULL,
	[MSTNgayCap] [datetime] NULL,
	[MSTNoiCap] [nvarchar](100) NULL,
	[QuocTich] [nvarchar](100) NULL,
	[PhoneRepresentation] [nvarchar](50) NULL,
	[Note] [nvarchar](max) NULL,
	[PersonRepresentation] [nvarchar](100) NULL,
	[Field] [nvarchar](100) NULL,
	[TypeCompany] [nvarchar](100) NULL,
	[TypeCustomer] [int] NULL,
	[NguonKhachHang] [nvarchar](max) NULL,
	[GroupCustomer] [nvarchar](100) NULL,
	[MaritalStatus] [int] NULL,
	[Status] [int] NULL,
	[Religion] [nvarchar](50) NULL,
	[TypeInput] [int] NULL,
	[ProjectId] [int] NULL,
	[TimeImport] [datetime] NULL,
	[EmailRepresentation] [nvarchar](50) NULL,
	[FamilySize] [int] NULL,
	[TeamManager] [nvarchar](100) NULL,
	[AgencyAccount] [nvarchar](50) NULL,
	[AgencyPassword] [nvarchar](50) NULL,
	[IsAgency] [bit] NOT NULL,
	[HistoryLog] [nvarchar](max) NULL,
	[RateStar] [int] NOT NULL,
 CONSTRAINT [PK_Customer_CTGroupBO] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer2]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer2](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NULL,
	[DateOfBirth] [date] NULL,
	[Gender] [int] NULL,
	[Phone] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[Address] [nvarchar](500) NULL,
	[CountryId] [int] NULL,
	[CityId] [int] NULL,
	[DistrictId] [int] NULL,
	[WardId] [int] NULL,
	[Company] [nvarchar](500) NULL,
	[CMND] [nvarchar](50) NULL,
	[MST] [nvarchar](50) NULL,
	[JobTitle] [nvarchar](100) NULL,
	[Website] [nvarchar](100) NULL,
	[Fax] [nvarchar](50) NULL,
	[IsCompany] [bit] NOT NULL,
	[IsPerson] [bit] NOT NULL,
	[IsSupplier] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[SaleId] [int] NULL,
	[MSTNgayCap] [datetime] NULL,
	[MSTNoiCap] [nvarchar](100) NULL,
	[QuocTich] [nvarchar](100) NULL,
	[PhoneRepresentation] [nvarchar](50) NULL,
	[Note] [nvarchar](max) NULL,
	[PersonRepresentation] [nvarchar](100) NULL,
	[Field] [nvarchar](100) NULL,
	[TypeCompany] [nvarchar](100) NULL,
	[TypeCustomer] [int] NULL,
	[NguonKhachHang] [nvarchar](max) NULL,
	[GroupCustomer] [nvarchar](100) NULL,
	[MaritalStatus] [int] NULL,
	[Status] [int] NULL,
	[Religion] [nvarchar](50) NULL,
	[TypeInput] [int] NULL,
	[ProjectId] [int] NULL,
	[TimeImport] [datetime] NULL,
	[EmailRepresentation] [nvarchar](50) NULL,
	[FamilySize] [int] NULL,
	[TeamManager] [nvarchar](100) NULL,
	[AgencyAccount] [nvarchar](50) NULL,
	[AgencyPassword] [nvarchar](50) NULL,
	[IsAgency] [bit] NOT NULL,
	[IsCandidate] [bit] NOT NULL,
	[CustomerId] [nvarchar](200) NULL,
	[ContractNumber] [nvarchar](100) NULL,
 CONSTRAINT [PK_Customer2_CTGroupBO] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerAccount]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerAccount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[AccountNumber] [nvarchar](50) NOT NULL,
	[BankName] [nvarchar](100) NOT NULL,
	[AccountName] [nvarchar](100) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_CustomerAccount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerContract]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerContract](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[Type] [int] NOT NULL,
	[ContractTemplateId] [int] NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Number] [nvarchar](50) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[SignatureDate] [date] NULL,
	[Note] [nvarchar](max) NULL,
	[AreaType] [int] NOT NULL,
	[Price] [decimal](12, 2) NULL,
	[Discount] [decimal](14, 2) NULL,
	[ProcessId] [int] NOT NULL,
	[SaleId] [int] NULL,
	[VAT] [decimal](4, 2) NULL,
	[PaymentProcessType] [int] NULL,
	[Commission] [decimal](4, 2) NULL,
	[SaleCommission] [decimal](4, 2) NULL,
	[SupportCommission] [decimal](4, 2) NULL,
	[CreateDate] [datetime] NULL,
	[TotalValue] [decimal](14, 2) NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_CustomerContract] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerLogs]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Phone] [nvarchar](200) NULL,
	[ContractNumber] [nvarchar](100) NULL,
 CONSTRAINT [PK_CustomerLogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DailyMenu]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyMenu](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderDate] [date] NULL,
 CONSTRAINT [PK_DailyMenu] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DailyMenuDetails]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DailyMenuDetails](
	[Id] [int] NOT NULL,
	[FoodId] [int] NOT NULL,
	[Quantity] [int] NULL,
 CONSTRAINT [PK_DailyMenuDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[FoodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Dictrict]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dictrict](
	[ID] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Type] [nvarchar](50) NULL,
	[CityID] [int] NULL,
 CONSTRAINT [PK_Dictrict] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Floor]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Floor](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[BlockId] [int] NULL,
	[Description] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Floor] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Food]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Food](
	[FoodId] [int] IDENTITY(1,1) NOT NULL,
	[FoodCode] [varchar](20) NULL,
	[Name] [nvarchar](max) NULL,
	[Image] [varchar](1000) NULL,
 CONSTRAINT [PK_Food] PRIMARY KEY CLUSTERED 
(
	[FoodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ForgetCheckTime]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ForgetCheckTime](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ForgetIn] [bit] NOT NULL,
	[ForgetOut] [bit] NOT NULL,
	[Reason] [nvarchar](max) NULL,
	[UserID] [int] NULL,
	[CreateTime] [datetime] NOT NULL,
	[Statuss] [int] NOT NULL,
 CONSTRAINT [PK_ForgetCheckTime] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Group]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Group](
	[GroupId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[CreateDate] [date] NULL,
	[Description] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Group] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Group_Permission]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Group_Permission](
	[GroupId] [int] NOT NULL,
	[PermissionId] [int] NOT NULL,
 CONSTRAINT [PK_UserGroup_Permission] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC,
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LeaveRecord]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LeaveRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NOT NULL,
	[FromDate] [date] NOT NULL,
	[FromTime] [int] NOT NULL,
	[ToDate] [date] NOT NULL,
	[ToTime] [int] NOT NULL,
	[TotalLeave] [decimal](3, 1) NOT NULL,
	[LeaveType] [int] NOT NULL,
	[Reason] [nvarchar](500) NOT NULL,
	[Status] [int] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[HrId] [nvarchar](50) NULL,
 CONSTRAINT [PK_LeaveRecord] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LunchRequest]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LunchRequest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IsCancelRequest] [bit] NOT NULL,
	[IsVegetarian] [bit] NOT NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[Reason] [nvarchar](500) NULL,
	[UserId] [int] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LunchRequestTotal]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LunchRequestTotal](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NOT NULL,
	[SaltyTotal] [int] NOT NULL,
	[VegetarianTotal] [int] NOT NULL,
	[SaltyNew] [int] NOT NULL,
	[VegetarianNew] [int] NOT NULL,
	[Status] [int] NOT NULL,
 CONSTRAINT [PK_LunchRequestTotal] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Nation]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
 CONSTRAINT [PK_Nation_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[NoteCheckTime]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NoteCheckTime](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DateNote] [date] NOT NULL,
	[Note] [nvarchar](500) NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_NoteCheckTime] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ParentTree]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ParentTree](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ParentID] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[SeqOder] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PaymentProcess]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentProcess](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[ContractId] [int] NOT NULL,
	[Percentage] [decimal](5, 2) NOT NULL,
	[AmountDue] [decimal](14, 2) NULL,
	[PayDate] [date] NOT NULL,
	[AmountPaid] [decimal](14, 2) NULL,
	[SaleCommission] [decimal](4, 2) NULL,
	[SupportCommission] [decimal](4, 2) NULL,
	[CreatedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_PaymentProcess] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PaymentRequest]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentRequest](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Type] [int] NOT NULL,
	[CustomerID] [int] NULL,
	[ProductID] [int] NOT NULL,
	[ContractID] [int] NULL,
	[Amount] [decimal](18, 0) NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[UserCreated] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_PaymentRequest] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PaymentRequestDetail]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PaymentRequestDetail](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Amount] [decimal](18, 0) NOT NULL,
	[Status] [int] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[UserCreated] [int] NOT NULL,
	[PaymentRequestID] [bigint] NOT NULL,
	[Type] [int] NOT NULL,
	[PaymentMethod] [int] NOT NULL,
	[BankAccount] [varchar](50) NULL,
	[BankAccountName] [nvarchar](2000) NULL,
	[BranchID] [int] NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Bill] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PositionCode]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PositionCode](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[LongName] [nvarchar](200) NULL,
	[DataLink] [nvarchar](500) NULL,
	[Department] [nvarchar](100) NULL,
 CONSTRAINT [PK_PositionCode] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProcessProject]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessProject](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NULL,
	[Name] [nvarchar](100) NULL,
	[Percent] [float] NULL,
	[ExpectedCompletion] [date] NULL,
	[FinishDay] [date] NULL,
	[Description] [nvarchar](4000) NULL,
	[LevyNoticeDay] [date] NULL,
 CONSTRAINT [PK_ProcessProject] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NULL,
	[ProductCode] [nvarchar](18) NULL,
	[GiaNhap] [decimal](12, 1) NULL,
	[HouseNumber] [nvarchar](256) NULL,
	[gia_ban] [decimal](12, 1) NULL,
	[don_gia] [decimal](12, 1) NULL,
	[vat] [int] NULL,
	[gia_co_dinh] [bit] NULL,
	[nguoi_tao] [int] NULL,
	[nguoi_sua] [int] NULL,
	[ngay_tao] [datetime] NULL,
	[ngay_sua] [datetime] NULL,
	[Status] [int] NOT NULL,
	[ProjectId] [int] NULL,
	[BlockId] [int] NULL,
	[FloorId] [int] NULL,
	[BathRoom] [int] NULL,
	[BedRoom] [int] NULL,
	[Direction] [int] NULL,
	[Desciption] [nvarchar](1000) NULL,
	[Trang_thai_kd] [bit] NULL,
	[Money] [int] NULL,
	[Dien_tich_tho] [decimal](12, 1) NULL,
	[Dien_tich_hoan_thien] [decimal](12, 1) NULL,
	[Don_gia_thong_thuy] [decimal](12, 1) NULL,
	[Dien_tich_thong_thuy] [decimal](12, 1) NULL,
	[View] [nvarchar](100) NULL,
	[Sale_assign] [int] NULL,
	[Sale_commit] [int] NULL,
	[Presenter] [int] NULL,
	[BookTime] [datetime] NULL,
	[KhachKyGui] [bit] NOT NULL,
	[BookUserId] [int] NULL,
 CONSTRAINT [PK_Product_CTGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Project]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Investor] [nvarchar](50) NULL,
	[CommencementDate] [date] NULL,
	[ExpectedCompletion] [date] NULL,
	[NationId] [int] NULL,
	[Addr] [nvarchar](100) NULL,
	[CityId] [int] NULL,
	[DistrictId] [int] NULL,
	[WardsId] [int] NULL,
	[Status] [int] NULL,
	[Description] [nvarchar](4000) NULL,
	[ProjectCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Project2]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project2](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Investor] [nvarchar](50) NULL,
	[CommencementDate] [date] NULL,
	[ExpectedCompletion] [date] NULL,
	[NationId] [int] NULL,
	[Addr] [nvarchar](100) NULL,
	[CityId] [int] NULL,
	[DistrictId] [int] NULL,
	[WardsId] [int] NULL,
	[Status] [int] NULL,
	[Description] [nvarchar](4000) NULL,
	[ProjectCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_Project2] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectAdmin]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectAdmin](
	[ProjectId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[IsSaleAdmin] [bit] NOT NULL,
 CONSTRAINT [PK_ProjectAdmin] PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectAssign]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectAssign](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[TeamId] [nvarchar](50) NOT NULL,
	[TeamName] [nvarchar](500) NULL,
 CONSTRAINT [PK_ProjectAssign] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ranking]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ranking](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](2000) NOT NULL,
	[Type] [int] NOT NULL,
	[Year] [int] NULL,
	[Month] [int] NULL,
	[Week] [int] NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Status] [int] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[UserCreated] [int] NOT NULL,
	[ManagerStartDate] [datetime] NOT NULL,
	[ManagerEndDate] [datetime] NULL,
 CONSTRAINT [PK_Ranking] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ranking_Result]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ranking_Result](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
	[Status] [int] NOT NULL,
	[RankingID] [int] NOT NULL,
	[ManagerID] [int] NOT NULL,
	[ManagerComment] [nvarchar](max) NULL,
	[PlanFile] [nvarchar](2000) NULL,
	[HRComment] [nvarchar](max) NULL,
 CONSTRAINT [PK_Ranking_Result] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ranking_ResultDetail]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ranking_ResultDetail](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[LSCriteriaID] [nvarchar](12) NOT NULL,
	[IsCheck] [bit] NOT NULL,
	[PointStaff] [int] NULL,
	[TimeCreated] [datetime] NOT NULL,
	[ResultID] [bigint] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[PointManager] [int] NULL,
	[IsCheckManager] [bit] NULL,
	[IsCheckHR] [bit] NULL,
	[PointHR] [int] NULL,
 CONSTRAINT [PK_Ranking_ResultDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ranking_ResultDetailHistory]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ranking_ResultDetailHistory](
	[ResultDetailID] [bigint] NOT NULL,
	[UserApproveID] [int] NOT NULL,
	[IsCheckManager] [bit] NULL,
	[PointManager] [int] NULL,
	[TimeCreated] [datetime] NULL,
 CONSTRAINT [PK_Ranking_ResultDetailHistory] PRIMARY KEY CLUSTERED 
(
	[ResultDetailID] ASC,
	[UserApproveID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ranking_ResultHistory]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ranking_ResultHistory](
	[ResultID] [bigint] NOT NULL,
	[ManagerID] [int] NOT NULL,
	[ApproveOrder] [int] NOT NULL,
	[TimeCreated] [datetime] NOT NULL,
 CONSTRAINT [PK_Ranking_ResultHistory] PRIMARY KEY CLUSTERED 
(
	[ResultID] ASC,
	[ManagerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ranking_Task]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ranking_Task](
	[LSCriteriaID] [nvarchar](12) NOT NULL,
	[LSCriteriaCode] [nvarchar](15) NULL,
	[Name] [nvarchar](2000) NULL,
	[IDParent] [nvarchar](12) NULL,
	[Rank] [int] NULL,
	[Note] [nvarchar](1000) NULL,
	[Used] [bit] NULL,
	[Point] [int] NULL,
	[IsSale] [bit] NOT NULL,
	[ShortName] [nvarchar](2000) NULL,
	[IsPercent] [bit] NULL,
 CONSTRAINT [PK_LS_tblAPPCriteria] PRIMARY KEY CLUSTERED 
(
	[LSCriteriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ranking_Template]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ranking_Template](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](2000) NULL,
	[TimeCreated] [datetime] NULL,
	[UserCreated] [int] NULL,
 CONSTRAINT [PK_Ranking_Template] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ranking_Template_Task]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ranking_Template_Task](
	[TemplateID] [int] NOT NULL,
	[LSCriteriaID] [nvarchar](12) NOT NULL,
 CONSTRAINT [PK_Ranking_Template_Task] PRIMARY KEY CLUSTERED 
(
	[TemplateID] ASC,
	[LSCriteriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubmissionFile]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubmissionFile](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileTypeId] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[UserId] [int] NOT NULL,
	[TimeCreate] [datetime] NOT NULL,
	[Status] [int] NOT NULL,
	[TimeApporve] [datetime] NULL,
	[CompanyId] [int] NOT NULL,
	[Code] [nvarchar](100) NULL,
	[Name] [nvarchar](200) NOT NULL,
	[BaseOn] [nvarchar](200) NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_SubmissionFile] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubmissionFileAttach]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubmissionFileAttach](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [nvarchar](200) NOT NULL,
	[Size] [int] NOT NULL,
	[SubmissionFileId] [int] NOT NULL,
	[TimeCreate] [datetime] NOT NULL,
 CONSTRAINT [PK_SubmissionFileAttach] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubmissionFileUser]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubmissionFileUser](
	[SubmissionFileId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[TimeCreate] [datetime] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[ApproveGroupID] [int] NOT NULL,
 CONSTRAINT [PK_SubmissionFileUser] PRIMARY KEY CLUSTERED 
(
	[SubmissionFileId] ASC,
	[UserId] ASC,
	[ApproveGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fullname] [nvarchar](50) NULL,
	[Username] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NULL,
	[DayOfBirth] [date] NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[Image] [nvarchar](255) NULL,
	[Description] [nvarchar](500) NULL,
	[EmployeeId] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[EmployeeStatus] [int] NULL,
	[Position] [nvarchar](255) NULL,
	[EmailCompany] [nvarchar](100) NULL,
	[StartDay] [date] NULL,
	[Block] [bit] NULL,
	[FingerprintCode] [nvarchar](50) NULL,
	[IsLdapUser] [bit] NOT NULL,
	[EndDate] [datetime] NULL,
	[Voip] [varchar](50) NULL,
	[PositionCode] [nvarchar](50) NULL,
	[DataFolder] [nvarchar](max) NULL,
	[ManagerId] [int] NULL,
	[LastSynHR] [datetime] NULL,
	[HasLunch] [bit] NOT NULL,
	[TerminationReason] [varchar](50) NULL,
	[TerminationNote] [nvarchar](500) NULL,
	[TerminationDate] [date] NULL,
	[RequestTerminationReason] [varchar](50) NULL,
	[RequestTerminationNote] [nvarchar](500) NULL,
	[DataFile] [varchar](max) NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[User_Group]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Group](
	[GroupId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_User_Group] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User_Permission]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_Permission](
	[UserId] [int] NOT NULL,
	[PermissionId] [int] NOT NULL,
 CONSTRAINT [PK_User_Permission] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[PermissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User2]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User2](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fullname] [nvarchar](50) NULL,
	[Username] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NULL,
	[Image] [nvarchar](255) NULL,
	[Description] [nvarchar](500) NULL,
	[EmployeeId] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[EmployeeStatus] [int] NULL,
	[Position] [nvarchar](255) NULL,
	[StartDay] [date] NULL,
	[Block] [bit] NULL,
	[FingerprintCode] [nvarchar](50) NULL,
	[EndDate] [datetime] NULL,
	[Voip] [varchar](50) NULL,
	[PositionCode] [nvarchar](50) NULL,
	[DataFolder] [nvarchar](max) NULL,
	[ManagerId] [int] NULL,
	[LastSynHR] [datetime] NULL,
	[HasLunch] [bit] NOT NULL,
	[TerminationReason] [varchar](50) NULL,
	[TerminationNote] [nvarchar](500) NULL,
	[TerminationDate] [date] NULL,
	[RequestTerminationReason] [varchar](50) NULL,
	[RequestTerminationNote] [nvarchar](500) NULL,
 CONSTRAINT [PK_User2] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserPositionMap]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserPositionMap](
	[UserId] [int] NOT NULL,
	[PositionCodeId] [int] NOT NULL,
 CONSTRAINT [PK_UserPositionMap] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[PositionCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Ward]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ward](
	[ID] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Type] [nvarchar](50) NULL,
	[DictrictID] [int] NULL,
 CONSTRAINT [PK_Ward] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[WorkLeaveType]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkLeaveType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](100) NULL,
 CONSTRAINT [PK_WorkLeaveType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [dbo].[fnGetChildUser]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[fnGetChildUser]
(
	@AdminID INT,
	@IncludeCurrent BIT
)
RETURNS TABLE 
AS
RETURN 
(
	/* http://msdn.microsoft.com/en-us/library/ms186243%28v=sql.105%29.aspx */
	WITH AdminTree(RootID, ManagerID, ID, Fullname, LEVEL, UserName)
	AS
	(
		SELECT u.ID, NULL, u.ID, u.Fullname, 0, u.Username AS UserName	
		FROM [User] AS u
		WHERE u.ID = @AdminID 
		---------
		UNION ALL
		---------
		SELECT at.RootID, u.ManagerID, u.ID, u.Fullname, Level + 1, u.Username AS UserName
		FROM [User] AS u INNER JOIN AdminTree at ON u.ManagerID = at.ID		
	)
	SELECT * FROM AdminTree
	WHERE (@IncludeCurrent = 0 AND ID <> @AdminID)
	OR (@IncludeCurrent = 1)
)
GO
/****** Object:  View [dbo].[HR_vAPPCriteria]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create  VIEW [dbo].[HR_vAPPCriteria]
AS
Select	*
	from	[HRM].SVHRISCTG.dbo.LS_tblAPPCriteria A
	where A.Used=1	

GO
/****** Object:  View [dbo].[HR_vDepartment]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  VIEW [dbo].[HR_vDepartment]
AS
Select	A2.*
	from	[HRM].SVHRISCTG.dbo.LS_tblLevel2 A2
	JOIN Hrm.SVHRISCTG.dbo.LS_tblLevel1Level2 A12 ON A12.LSLevel2ID = A2.LSLevel2ID
	JOIN HRM.SVHRISCTG.dbo.LS_tblLevel1 A1 ON A1.LSLevel1ID = A12.LSLevel1ID
	where A2.Used=1 AND A1.LSCompanyID = '01' AND A1.Used = 1
	


GO
/****** Object:  View [dbo].[HR_vEmpList]    Script Date: 12/7/2016 5:15:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  VIEW [dbo].[HR_vEmpList]
AS
Select	A.EmpID, B.EmpCode, B.EmpCodeOld, A.VLastName, A.VFirstName, rtrim(A.VLastName) + ' ' + A.VFirstName AS EmpName, A.NickName,
		Convert(nvarchar, A.DOB, 103) DOBStr, A.DOB,  
		A.Gender, Case when A.Gender = 1 then 'Male' else 'Female' end GenderStr, A.IsScan,
		Convert(nvarchar, B.StartDate, 103) StartDateStr, B.StartDate, 
		B.LSCompanyID, H.LSCompanyCode, H.Name CompanyEN, H.VNName CompanyVN, H.ShortName CompanyShortName,
		B.LSLocationID, F.LSLocationCode, F.Name LocationEN, F.VNName LocationVN, F.DisplayName LocDisplayName,
		B.LSLevel1ID, C.LSLevel1Code, C.Name Level1EN, C.VNName Level1VN, C.ShortName Level1ShortName,
		B.LSLevel2ID, D.LSLevel2Code, D.Name Level2EN, D.VNName Level2VN, D.ShortName Level2ShortName,
		B.LSLevel3ID, E.LSLevel3Code, E.Name Level3EN, E.VNName Level3VN, E.ShortName Level3ShortName,
		B.LSLevel4ID,S.LSLevel4Code,s.Name Level4EN,S.VNName Level4VN,s.ShortName Level4ShortName,
		B.LSLevel5ID,X.LSLevel5Code,X.Name Level5EN,X.VNName Level5VN,X.ShortName Level5ShortName,
		B.LSPositionID, G.LSPositionCode, G.Name PositionEN, G.VNName PositionVN,
		B.LSEmpTypeID, I.VNName EmpTypeVN, I.Name EmpTypeEN,
		B.Active Status, IDNo,
		B.LSJobTitleID ,j.LSJobTitleCode, J.VNName JobTitleVN, J.Name JobTitleEN, j.ShortName as JobTitleShortName, B.Active
		, InterviewDate, ProbationFrom, ProbationEnd, EmpID_ReportTo, 
		ProbationExtendFrom, ProbationExtendEnd, ApprenticeFrom, ApprenticeEnd
		, b.EmailComp, b.UserName, A.ScanCode,B.ShiftID,B.TimeSheetHand,
		isnull(B.KeyNum,'') as KeyNum,K.LSBranchBlockID
	from	[HRM].SVHRISCTG.dbo.HR_tblEmpCV A inner join [HRM].SVHRISCTG.dbo.HR_tblEmp B on A.EmpID = B.EmpID
		left join [HRM].SVHRISCTG.dbo.LS_tblLevel1 C ON B.LSLevel1ID = C.LSLevel1ID
                left join [HRM].SVHRISCTG.dbo.LS_tblLevel2 D ON B.LSLevel2ID = D.LSLevel2ID 
                left join [HRM].SVHRISCTG.dbo.LS_tblLevel3 E ON B.LSLevel3ID = E.LSLevel3ID
                left join [HRM].SVHRISCTG.dbo.LS_tblLevel4 S ON B.LSLevel4ID = S.LSLevel4ID
                left join [HRM].SVHRISCTG.dbo.LS_tblLevel5 X ON B.LSLevel5ID = X.LSLevel5ID
                left join [HRM].SVHRISCTG.dbo.LS_tblLocation F ON B.LSLocationID = F.LSLocationID
                left join [HRM].SVHRISCTG.dbo.LS_tblPosition G ON B.LSPositionID = G.LSPositionID
	left join [HRM].SVHRISCTG.dbo.LS_tblCompany H ON B.LSCompanyID = H.LSCompanyID
	left join [HRM].SVHRISCTG.dbo.LS_tblJobTitle J ON J.LSJobTitleID  = B.LSJobTitleID
	left join [HRM].SVHRISCTG.dbo.LS_tblEmpType I on I.LSEmpTypeID = B.LSEmpTypeID
	left join [HRM].SVHRISCTG.dbo.LS_tblBranchBlock K on K.LSBranchBlockID=A.LSBranchBlockID

GO
ALTER TABLE [dbo].[ApproveAutoConfig] ADD  CONSTRAINT [DF_ApproveAutoConfig_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[ApproveAutoConfig] ADD  CONSTRAINT [DF_ApproveAutoConfig_SubLevelType]  DEFAULT ((1)) FOR [SubLevelType]
GO
ALTER TABLE [dbo].[ApproveGroup] ADD  CONSTRAINT [DF_ApproveGroup_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[ApproveGroupUser] ADD  CONSTRAINT [DF_ApproveGroupUser_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[ApproveTransaction] ADD  CONSTRAINT [DF_ApproveTransaction_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[Bank] ADD  CONSTRAINT [DF_Bank_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[Bank] ADD  CONSTRAINT [DF_Bank_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[BankBranch] ADD  CONSTRAINT [DF_BankBranch_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[BankBranch] ADD  CONSTRAINT [DF_BankBranch_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[CallLog] ADD  CONSTRAINT [DF_CallLog_Type]  DEFAULT ((0)) FOR [Type]
GO
ALTER TABLE [dbo].[CallLog] ADD  CONSTRAINT [DF_CallLog_IsImport]  DEFAULT ((1)) FOR [IsImport]
GO
ALTER TABLE [dbo].[Career] ADD  CONSTRAINT [DF_Career_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[CommonQuestion] ADD  CONSTRAINT [DF_CommonQuestion_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Company] ADD  CONSTRAINT [DF_Company_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_CreatedOn]  DEFAULT ('2016-9-1') FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_IsAgency_1]  DEFAULT ((0)) FOR [IsAgency]
GO
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_RateStar]  DEFAULT ((0)) FOR [RateStar]
GO
ALTER TABLE [dbo].[LunchRequestTotal] ADD  CONSTRAINT [DF_LunchRequestTotal_SaltyTotal]  DEFAULT ((0)) FOR [SaltyTotal]
GO
ALTER TABLE [dbo].[LunchRequestTotal] ADD  CONSTRAINT [DF_LunchRequestTotal_VegetarianTotal]  DEFAULT ((0)) FOR [VegetarianTotal]
GO
ALTER TABLE [dbo].[LunchRequestTotal] ADD  CONSTRAINT [DF_LunchRequestTotal_SaltyNew]  DEFAULT ((0)) FOR [SaltyNew]
GO
ALTER TABLE [dbo].[LunchRequestTotal] ADD  CONSTRAINT [DF_LunchRequestTotal_VegetarianNew]  DEFAULT ((0)) FOR [VegetarianNew]
GO
ALTER TABLE [dbo].[PaymentRequest] ADD  CONSTRAINT [DF_PaymentRequest_Amount]  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[PaymentRequest] ADD  CONSTRAINT [DF_PaymentRequest_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[PaymentRequestDetail] ADD  CONSTRAINT [DF_Bill_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_KhachKyGui]  DEFAULT ((0)) FOR [KhachKyGui]
GO
ALTER TABLE [dbo].[ProjectAdmin] ADD  CONSTRAINT [DF_ProjectAdmin_IsSaleAdmin]  DEFAULT ((1)) FOR [IsSaleAdmin]
GO
ALTER TABLE [dbo].[Ranking] ADD  CONSTRAINT [DF_Ranking_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[Ranking_Result] ADD  CONSTRAINT [DF_Ranking_Result_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[Ranking_ResultDetail] ADD  CONSTRAINT [DF_Ranking_ResultDetail_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[Ranking_ResultDetailHistory] ADD  CONSTRAINT [DF_Ranking_ResultDetailHistory_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[Ranking_ResultHistory] ADD  CONSTRAINT [DF_Ranking_ResultHistory_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[Ranking_Task] ADD  CONSTRAINT [DF_Ranking_Task_IsSale]  DEFAULT ((0)) FOR [IsSale]
GO
ALTER TABLE [dbo].[Ranking_Task] ADD  CONSTRAINT [DF_Ranking_Task_DataType]  DEFAULT ((0)) FOR [IsPercent]
GO
ALTER TABLE [dbo].[Ranking_Template] ADD  CONSTRAINT [DF_Ranking_Template_TimeCreated]  DEFAULT (getdate()) FOR [TimeCreated]
GO
ALTER TABLE [dbo].[SubmissionFileUser] ADD  CONSTRAINT [DF_SubmissionFileUser_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[SubmissionFileUser] ADD  CONSTRAINT [DF_SubmissionFileUser_ApproveGroupID]  DEFAULT ((0)) FOR [ApproveGroupID]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_IsLdap]  DEFAULT ((1)) FOR [IsLdapUser]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_HasLunch]  DEFAULT ((1)) FOR [HasLunch]
GO
ALTER TABLE [dbo].[ActivityLog]  WITH CHECK ADD  CONSTRAINT [FK_ActivityLog_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[ActivityLog] CHECK CONSTRAINT [FK_ActivityLog_User]
GO
ALTER TABLE [dbo].[ApproveAutoConfig]  WITH CHECK ADD  CONSTRAINT [FK_ApproveAutoConfig_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[ApproveAutoConfig] CHECK CONSTRAINT [FK_ApproveAutoConfig_User]
GO
ALTER TABLE [dbo].[ApproveGroupUser]  WITH CHECK ADD  CONSTRAINT [FK_ApproveGroupUser_ApproveGroup] FOREIGN KEY([ApproveGroupID])
REFERENCES [dbo].[ApproveGroup] ([ID])
GO
ALTER TABLE [dbo].[ApproveGroupUser] CHECK CONSTRAINT [FK_ApproveGroupUser_ApproveGroup]
GO
ALTER TABLE [dbo].[ApproveGroupUser]  WITH CHECK ADD  CONSTRAINT [FK_ApproveGroupUser_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[ApproveGroupUser] CHECK CONSTRAINT [FK_ApproveGroupUser_User]
GO
ALTER TABLE [dbo].[ApproveTransaction]  WITH CHECK ADD  CONSTRAINT [FK_ApproveTransaction_User] FOREIGN KEY([NextApprove])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[ApproveTransaction] CHECK CONSTRAINT [FK_ApproveTransaction_User]
GO
ALTER TABLE [dbo].[ApproveTransactionHistory]  WITH CHECK ADD  CONSTRAINT [FK_ApproveTransactionHistory_ApproveTransaction] FOREIGN KEY([ApproveTransactionID])
REFERENCES [dbo].[ApproveTransaction] ([ID])
GO
ALTER TABLE [dbo].[ApproveTransactionHistory] CHECK CONSTRAINT [FK_ApproveTransactionHistory_ApproveTransaction]
GO
ALTER TABLE [dbo].[ApproveTransactionHistory]  WITH CHECK ADD  CONSTRAINT [FK_ApproveTransactionHistory_User] FOREIGN KEY([UserApproved])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[ApproveTransactionHistory] CHECK CONSTRAINT [FK_ApproveTransactionHistory_User]
GO
ALTER TABLE [dbo].[BankBranch]  WITH CHECK ADD  CONSTRAINT [FK_BankBranch_Bank] FOREIGN KEY([BankID])
REFERENCES [dbo].[Bank] ([ID])
GO
ALTER TABLE [dbo].[BankBranch] CHECK CONSTRAINT [FK_BankBranch_Bank]
GO
ALTER TABLE [dbo].[Block]  WITH CHECK ADD  CONSTRAINT [FK_Block_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[Block] CHECK CONSTRAINT [FK_Block_Project]
GO
ALTER TABLE [dbo].[CallLog]  WITH CHECK ADD  CONSTRAINT [FK_CallCenter_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[CallLog] CHECK CONSTRAINT [FK_CallCenter_Customer]
GO
ALTER TABLE [dbo].[CandidateCareer]  WITH CHECK ADD  CONSTRAINT [FK_CandidateCareer_Candidate] FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidate] ([Id])
GO
ALTER TABLE [dbo].[CandidateCareer] CHECK CONSTRAINT [FK_CandidateCareer_Candidate]
GO
ALTER TABLE [dbo].[CandidateCareer]  WITH CHECK ADD  CONSTRAINT [FK_CandidateCareer_Career] FOREIGN KEY([CareerId])
REFERENCES [dbo].[Career] ([Id])
GO
ALTER TABLE [dbo].[CandidateCareer] CHECK CONSTRAINT [FK_CandidateCareer_Career]
GO
ALTER TABLE [dbo].[CommonQuestion_CallLog]  WITH CHECK ADD  CONSTRAINT [FK_CommonQuestion_CallLog_CallLog] FOREIGN KEY([CallLogId])
REFERENCES [dbo].[CallLog] ([Id])
GO
ALTER TABLE [dbo].[CommonQuestion_CallLog] CHECK CONSTRAINT [FK_CommonQuestion_CallLog_CallLog]
GO
ALTER TABLE [dbo].[CommonQuestion_CallLog]  WITH CHECK ADD  CONSTRAINT [FK_CommonQuestion_CallLog_CommonQuestion] FOREIGN KEY([CommonQuestionId])
REFERENCES [dbo].[CommonQuestion] ([Id])
GO
ALTER TABLE [dbo].[CommonQuestion_CallLog] CHECK CONSTRAINT [FK_CommonQuestion_CallLog_CommonQuestion]
GO
ALTER TABLE [dbo].[ContractCommission]  WITH CHECK ADD  CONSTRAINT [FK_ContractCommission_CustomerContract] FOREIGN KEY([ContractId])
REFERENCES [dbo].[CustomerContract] ([Id])
GO
ALTER TABLE [dbo].[ContractCommission] CHECK CONSTRAINT [FK_ContractCommission_CustomerContract]
GO
ALTER TABLE [dbo].[ContractFile]  WITH CHECK ADD  CONSTRAINT [FK_ContractFile_CustomerContract] FOREIGN KEY([ContractId])
REFERENCES [dbo].[CustomerContract] ([Id])
GO
ALTER TABLE [dbo].[ContractFile] CHECK CONSTRAINT [FK_ContractFile_CustomerContract]
GO
ALTER TABLE [dbo].[ContractTemplate]  WITH CHECK ADD  CONSTRAINT [FK_ContractTemplate_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[ContractTemplate] CHECK CONSTRAINT [FK_ContractTemplate_Project]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Project]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_User] FOREIGN KEY([SaleId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_User]
GO
ALTER TABLE [dbo].[CustomerAccount]  WITH CHECK ADD  CONSTRAINT [FK_CustomerAccount_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[CustomerAccount] CHECK CONSTRAINT [FK_CustomerAccount_Customer]
GO
ALTER TABLE [dbo].[CustomerContract]  WITH CHECK ADD  CONSTRAINT [FK_CustomerContract_ContractTemplate] FOREIGN KEY([ContractTemplateId])
REFERENCES [dbo].[ContractTemplate] ([Id])
GO
ALTER TABLE [dbo].[CustomerContract] CHECK CONSTRAINT [FK_CustomerContract_ContractTemplate]
GO
ALTER TABLE [dbo].[CustomerContract]  WITH CHECK ADD  CONSTRAINT [FK_CustomerContract_Customer] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[CustomerContract] CHECK CONSTRAINT [FK_CustomerContract_Customer]
GO
ALTER TABLE [dbo].[CustomerContract]  WITH CHECK ADD  CONSTRAINT [FK_CustomerContract_Product1] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[CustomerContract] CHECK CONSTRAINT [FK_CustomerContract_Product1]
GO
ALTER TABLE [dbo].[CustomerContract]  WITH CHECK ADD  CONSTRAINT [FK_CustomerContract_User] FOREIGN KEY([SaleId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[CustomerContract] CHECK CONSTRAINT [FK_CustomerContract_User]
GO
ALTER TABLE [dbo].[DailyMenuDetails]  WITH CHECK ADD  CONSTRAINT [FK_DailyMenu] FOREIGN KEY([Id])
REFERENCES [dbo].[DailyMenu] ([Id])
GO
ALTER TABLE [dbo].[DailyMenuDetails] CHECK CONSTRAINT [FK_DailyMenu]
GO
ALTER TABLE [dbo].[DailyMenuDetails]  WITH CHECK ADD  CONSTRAINT [FK_Food] FOREIGN KEY([FoodId])
REFERENCES [dbo].[Food] ([FoodId])
GO
ALTER TABLE [dbo].[DailyMenuDetails] CHECK CONSTRAINT [FK_Food]
GO
ALTER TABLE [dbo].[Dictrict]  WITH CHECK ADD  CONSTRAINT [FK_Dictrict_City] FOREIGN KEY([CityID])
REFERENCES [dbo].[City] ([ID])
GO
ALTER TABLE [dbo].[Dictrict] CHECK CONSTRAINT [FK_Dictrict_City]
GO
ALTER TABLE [dbo].[Floor]  WITH CHECK ADD  CONSTRAINT [FK_Floor_Block] FOREIGN KEY([BlockId])
REFERENCES [dbo].[Block] ([Id])
GO
ALTER TABLE [dbo].[Floor] CHECK CONSTRAINT [FK_Floor_Block]
GO
ALTER TABLE [dbo].[ForgetCheckTime]  WITH CHECK ADD  CONSTRAINT [FK_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[ForgetCheckTime] CHECK CONSTRAINT [FK_User]
GO
ALTER TABLE [dbo].[Group_Permission]  WITH CHECK ADD  CONSTRAINT [FK_Group_Permission_Group] FOREIGN KEY([GroupId])
REFERENCES [dbo].[Group] ([GroupId])
GO
ALTER TABLE [dbo].[Group_Permission] CHECK CONSTRAINT [FK_Group_Permission_Group]
GO
ALTER TABLE [dbo].[LeaveRecord]  WITH CHECK ADD  CONSTRAINT [FK_LeaveRecord_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[LeaveRecord] CHECK CONSTRAINT [FK_LeaveRecord_User]
GO
ALTER TABLE [dbo].[LeaveRecord]  WITH CHECK ADD  CONSTRAINT [FK_LeaveRecord_WorkLeaveType] FOREIGN KEY([LeaveType])
REFERENCES [dbo].[WorkLeaveType] ([Id])
GO
ALTER TABLE [dbo].[LeaveRecord] CHECK CONSTRAINT [FK_LeaveRecord_WorkLeaveType]
GO
ALTER TABLE [dbo].[LunchRequest]  WITH CHECK ADD  CONSTRAINT [FK_LunchRequest_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[LunchRequest] CHECK CONSTRAINT [FK_LunchRequest_User]
GO
ALTER TABLE [dbo].[NoteCheckTime]  WITH CHECK ADD  CONSTRAINT [FK_NoteCheckTime_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[NoteCheckTime] CHECK CONSTRAINT [FK_NoteCheckTime_User]
GO
ALTER TABLE [dbo].[PaymentProcess]  WITH CHECK ADD  CONSTRAINT [FK_PaymentProcess_CustomerContract] FOREIGN KEY([ContractId])
REFERENCES [dbo].[CustomerContract] ([Id])
GO
ALTER TABLE [dbo].[PaymentProcess] CHECK CONSTRAINT [FK_PaymentProcess_CustomerContract]
GO
ALTER TABLE [dbo].[PaymentRequest]  WITH CHECK ADD  CONSTRAINT [FK_PaymentRequest_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[PaymentRequest] CHECK CONSTRAINT [FK_PaymentRequest_Customer]
GO
ALTER TABLE [dbo].[PaymentRequest]  WITH CHECK ADD  CONSTRAINT [FK_PaymentRequest_CustomerContract] FOREIGN KEY([ContractID])
REFERENCES [dbo].[CustomerContract] ([Id])
GO
ALTER TABLE [dbo].[PaymentRequest] CHECK CONSTRAINT [FK_PaymentRequest_CustomerContract]
GO
ALTER TABLE [dbo].[PaymentRequest]  WITH CHECK ADD  CONSTRAINT [FK_PaymentRequest_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([Id])
GO
ALTER TABLE [dbo].[PaymentRequest] CHECK CONSTRAINT [FK_PaymentRequest_Product]
GO
ALTER TABLE [dbo].[PaymentRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_Bill_PaymentRequest] FOREIGN KEY([PaymentRequestID])
REFERENCES [dbo].[PaymentRequest] ([ID])
GO
ALTER TABLE [dbo].[PaymentRequestDetail] CHECK CONSTRAINT [FK_Bill_PaymentRequest]
GO
ALTER TABLE [dbo].[PaymentRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_PaymentRequestDetail_BankBranch] FOREIGN KEY([BranchID])
REFERENCES [dbo].[BankBranch] ([ID])
GO
ALTER TABLE [dbo].[PaymentRequestDetail] CHECK CONSTRAINT [FK_PaymentRequestDetail_BankBranch]
GO
ALTER TABLE [dbo].[ProcessProject]  WITH CHECK ADD  CONSTRAINT [FK_ProcessProject_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[ProcessProject] CHECK CONSTRAINT [FK_ProcessProject_Project]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_Project]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_City] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([ID])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_City]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_Dictrict] FOREIGN KEY([DistrictId])
REFERENCES [dbo].[Dictrict] ([ID])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_Dictrict]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_Ward] FOREIGN KEY([WardsId])
REFERENCES [dbo].[Ward] ([ID])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_Ward]
GO
ALTER TABLE [dbo].[ProjectAdmin]  WITH CHECK ADD  CONSTRAINT [FK_ProjectAdmin_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[ProjectAdmin] CHECK CONSTRAINT [FK_ProjectAdmin_Project]
GO
ALTER TABLE [dbo].[ProjectAdmin]  WITH CHECK ADD  CONSTRAINT [FK_ProjectAdmin_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[ProjectAdmin] CHECK CONSTRAINT [FK_ProjectAdmin_User]
GO
ALTER TABLE [dbo].[ProjectAssign]  WITH CHECK ADD  CONSTRAINT [FK_ProjectAssign_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[ProjectAssign] CHECK CONSTRAINT [FK_ProjectAssign_Project]
GO
ALTER TABLE [dbo].[Ranking_Result]  WITH CHECK ADD  CONSTRAINT [FK_Ranking_Result_User] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Ranking_Result] CHECK CONSTRAINT [FK_Ranking_Result_User]
GO
ALTER TABLE [dbo].[Ranking_ResultDetail]  WITH CHECK ADD  CONSTRAINT [FK_Ranking_ResultDetail_Ranking_Result] FOREIGN KEY([ResultID])
REFERENCES [dbo].[Ranking_Result] ([ID])
GO
ALTER TABLE [dbo].[Ranking_ResultDetail] CHECK CONSTRAINT [FK_Ranking_ResultDetail_Ranking_Result]
GO
ALTER TABLE [dbo].[Ranking_ResultDetail]  WITH CHECK ADD  CONSTRAINT [FK_Ranking_ResultDetail_Ranking_Task] FOREIGN KEY([LSCriteriaID])
REFERENCES [dbo].[Ranking_Task] ([LSCriteriaID])
GO
ALTER TABLE [dbo].[Ranking_ResultDetail] CHECK CONSTRAINT [FK_Ranking_ResultDetail_Ranking_Task]
GO
ALTER TABLE [dbo].[Ranking_ResultDetailHistory]  WITH CHECK ADD  CONSTRAINT [FK_Ranking_ResultDetailHistory_Ranking_ResultDetail] FOREIGN KEY([ResultDetailID])
REFERENCES [dbo].[Ranking_ResultDetail] ([ID])
GO
ALTER TABLE [dbo].[Ranking_ResultDetailHistory] CHECK CONSTRAINT [FK_Ranking_ResultDetailHistory_Ranking_ResultDetail]
GO
ALTER TABLE [dbo].[Ranking_ResultDetailHistory]  WITH CHECK ADD  CONSTRAINT [FK_Ranking_ResultDetailHistory_User] FOREIGN KEY([UserApproveID])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Ranking_ResultDetailHistory] CHECK CONSTRAINT [FK_Ranking_ResultDetailHistory_User]
GO
ALTER TABLE [dbo].[Ranking_ResultHistory]  WITH CHECK ADD  CONSTRAINT [FK_Ranking_ResultHistory_Ranking_Result] FOREIGN KEY([ResultID])
REFERENCES [dbo].[Ranking_Result] ([ID])
GO
ALTER TABLE [dbo].[Ranking_ResultHistory] CHECK CONSTRAINT [FK_Ranking_ResultHistory_Ranking_Result]
GO
ALTER TABLE [dbo].[Ranking_ResultHistory]  WITH CHECK ADD  CONSTRAINT [FK_Ranking_ResultHistory_User] FOREIGN KEY([ManagerID])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[Ranking_ResultHistory] CHECK CONSTRAINT [FK_Ranking_ResultHistory_User]
GO
ALTER TABLE [dbo].[Ranking_Template_Task]  WITH CHECK ADD  CONSTRAINT [FK_Ranking_Template_Task_Ranking_Task] FOREIGN KEY([LSCriteriaID])
REFERENCES [dbo].[Ranking_Task] ([LSCriteriaID])
GO
ALTER TABLE [dbo].[Ranking_Template_Task] CHECK CONSTRAINT [FK_Ranking_Template_Task_Ranking_Task]
GO
ALTER TABLE [dbo].[Ranking_Template_Task]  WITH CHECK ADD  CONSTRAINT [FK_Ranking_Template_Task_Ranking_Template] FOREIGN KEY([TemplateID])
REFERENCES [dbo].[Ranking_Template] ([ID])
GO
ALTER TABLE [dbo].[Ranking_Template_Task] CHECK CONSTRAINT [FK_Ranking_Template_Task_Ranking_Template]
GO
ALTER TABLE [dbo].[SubmissionFile]  WITH CHECK ADD  CONSTRAINT [FK_SubmissionFile_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([ID])
GO
ALTER TABLE [dbo].[SubmissionFile] CHECK CONSTRAINT [FK_SubmissionFile_Company]
GO
ALTER TABLE [dbo].[SubmissionFile]  WITH CHECK ADD  CONSTRAINT [FK_SubmissionFile_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[SubmissionFile] CHECK CONSTRAINT [FK_SubmissionFile_User]
GO
ALTER TABLE [dbo].[SubmissionFileAttach]  WITH CHECK ADD  CONSTRAINT [FK_SubmissionFileAttach_SubmissionFile] FOREIGN KEY([SubmissionFileId])
REFERENCES [dbo].[SubmissionFile] ([ID])
GO
ALTER TABLE [dbo].[SubmissionFileAttach] CHECK CONSTRAINT [FK_SubmissionFileAttach_SubmissionFile]
GO
ALTER TABLE [dbo].[SubmissionFileUser]  WITH CHECK ADD  CONSTRAINT [FK_SubmissionFileApprove_SubmissionFile] FOREIGN KEY([SubmissionFileId])
REFERENCES [dbo].[SubmissionFile] ([ID])
GO
ALTER TABLE [dbo].[SubmissionFileUser] CHECK CONSTRAINT [FK_SubmissionFileApprove_SubmissionFile]
GO
ALTER TABLE [dbo].[SubmissionFileUser]  WITH CHECK ADD  CONSTRAINT [FK_SubmissionFileUser_ApproveGroup] FOREIGN KEY([ApproveGroupID])
REFERENCES [dbo].[ApproveGroup] ([ID])
GO
ALTER TABLE [dbo].[SubmissionFileUser] CHECK CONSTRAINT [FK_SubmissionFileUser_ApproveGroup]
GO
ALTER TABLE [dbo].[SubmissionFileUser]  WITH CHECK ADD  CONSTRAINT [FK_SubmissionFileUser_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[SubmissionFileUser] CHECK CONSTRAINT [FK_SubmissionFileUser_User]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_User] FOREIGN KEY([ManagerId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_User]
GO
ALTER TABLE [dbo].[User_Group]  WITH CHECK ADD  CONSTRAINT [FK_User_Group_Group] FOREIGN KEY([GroupId])
REFERENCES [dbo].[Group] ([GroupId])
GO
ALTER TABLE [dbo].[User_Group] CHECK CONSTRAINT [FK_User_Group_Group]
GO
ALTER TABLE [dbo].[User_Group]  WITH CHECK ADD  CONSTRAINT [FK_User_Group_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[User_Group] CHECK CONSTRAINT [FK_User_Group_User]
GO
ALTER TABLE [dbo].[User_Permission]  WITH CHECK ADD  CONSTRAINT [FK_User_Permission_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[User_Permission] CHECK CONSTRAINT [FK_User_Permission_User]
GO
ALTER TABLE [dbo].[UserPositionMap]  WITH CHECK ADD  CONSTRAINT [FK_UserPositionMap_PositionCode] FOREIGN KEY([PositionCodeId])
REFERENCES [dbo].[PositionCode] ([Id])
GO
ALTER TABLE [dbo].[UserPositionMap] CHECK CONSTRAINT [FK_UserPositionMap_PositionCode]
GO
ALTER TABLE [dbo].[UserPositionMap]  WITH CHECK ADD  CONSTRAINT [FK_UserPositionMap_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[UserPositionMap] CHECK CONSTRAINT [FK_UserPositionMap_User]
GO
ALTER TABLE [dbo].[Ward]  WITH CHECK ADD  CONSTRAINT [FK_Ward_Dictrict] FOREIGN KEY([DictrictID])
REFERENCES [dbo].[Dictrict] ([ID])
GO
ALTER TABLE [dbo].[Ward] CHECK CONSTRAINT [FK_Ward_Dictrict]
GO
USE [master]
GO
ALTER DATABASE [CTGroupBO] SET  READ_WRITE 
GO
