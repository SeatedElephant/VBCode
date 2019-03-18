Imports System
Imports System.IO
Imports System.Web.UI
Imports System.Web
Imports System.Data
Imports System.Data.SqlClient

Partial Class deSitRepEdit
    Inherits System.Web.UI.Page

    'Declare global variables (have declared all as global
    Dim myConnection As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("cn_IRIS").ConnectionString)
    Dim myDataAdapter As SqlDataAdapter
    Dim cmd As New SqlCommand
	Dim comClause As String
	Dim comResults As DataTable
    Dim fetchClause As String
    Dim fetchResults As DataSet
    Dim fetchTable As DataTable
    Dim pageds As New PagedDataSource()
	Dim pagesReset as String
	Dim pgStart as Integer
	Dim pgEnd as Integer
	Dim pgCount as Integer
	Dim pgShift as Integer = 15
	Dim pageCmd as String
	Dim commandString() As String
	Dim comDate as String
	Dim cmdText as String
	Dim DateFull as String
	Dim sqlDate as String
    Dim insCheck As String
    Dim srId As String	
	Dim DelID As String
	Dim matCheck as Integer
	Dim DCPrAd as String
	Dim DCOiAE as String
	Dim DCAdmi as String
	Dim ADUiAE as String
	Dim ADAPNB as String
	Dim ADGPEO as String
	Dim ADESAB as String
	Dim ADPIWT as String
	Dim ADOfRe as String
	Dim ADConv as String
	Dim CaCuED as String
	Dim CaCoDi as String
	Dim CaQuDi as String
	Dim PreInt as Integer

    Sub Page_Load(sender As Object, e As EventArgs) Handles MyBase.Load
		if Not IsPostBack Then
            getRecords()
        End If
	End Sub	
	
	Protected Sub hideAll()
		editSummary.Style.Add("display","none")
		editSitRep.Style.Add("display","none")
   	End Sub

    Protected Sub getRecords()
        If ddlHosp.SelectedItem.Value = "All" Then
			editSearch.Text = "Select * from DE_SitRep_VW order by SR_Date desc, SR_Time desc"
        Else
			editSearch.Text = "Select * from DE_SitRep_VW Where SR_Site='" + ddlHosp.SelectedItem.Value + "' order by SR_Date desc, SR_Time desc"
		End If
        ViewState("PageNumber") = Convert.ToInt32(0)
        resetPaging()
        getResults()
    End Sub
	
	Protected Sub resetPaging()
		pgStart = 0
		pgEnd = pgShift -1
		pageStart.text = pgStart
		pageEnd.text = pgEnd
		ViewState("PageNumber") = Convert.ToInt32(pgStart)
	End Sub   
	
	Protected Sub getResults()
		hideAll()
		editSummary.Style.Add("display","block")
		IF String.IsNullOrEmpty(editSearch.text).ToString.Trim THEN 
			hideAll()
		ELSE
			myConnection.open()
			cmd.Connection = myConnection
			comClause = editSearch.text
			myDataAdapter = New SqlDataAdapter(comClause, myConnection)
			comResults = new DataTable()
			myDataAdapter.Fill(comResults)
			Dim dv = new DataView(comResults)
			pageds.DataSource = dv
			pageds.AllowPaging = True
			pageds.PageSize = 4
			If ViewState("PageNumber") IsNot Nothing Then
				pageds.CurrentPageIndex = Convert.ToInt32(ViewState("PageNumber"))
			Else
				pageds.CurrentPageIndex = 0
			End If
			pagesReset = "N"
			Dim pages As New ArrayList()
			PageCount.text = pageds.PageCount - 1
			pgCount = pageds.PageCount - 1
			IF pgCount < pgEnd Then
				pgEnd = pgCount
			End IF
			IF pgStart > 0 then
				pages.Add("<<")
			End IF
			For i As Integer = pgStart To pgEnd
				IF i = pageds.CurrentPageIndex THEN
					pages.Add("<strong>"+(i + 1).ToString()+"</strong>")
				ELSE
					pages.Add((i + 1).ToString())
				END IF
			Next
			IF pgCount > pgEnd THEN 
				Pages.Add(">>")
			END IF 
			patPage.DataSource = pages
			patPage.DataBind()
			editRepeater.DataSource = pageds
			editRepeater.DataBind()
			myConnection.close()
		End IF
	End Sub
	
	Protected Sub patPaging(sender As Object, e As RepeaterCommandEventArgs)
		pageCmd=e.CommandArgument
		pageCmd=pageCmd.replace("<strong>","")
		pageCmd=pageCmd.replace("</strong>","")
		IF pageCmd = "<<" THEN 
			pgStart = Convert.ToInt32(pageStart.text)-pgShift
			pgEnd = Convert.ToInt32(pageEnd.text)-pgShift
			ViewState("PageNumber") = Convert.ToInt32(pgStart)
		ELSE
			IF pageCmd = ">>" THEN 
				pgStart = Convert.ToInt32(pageStart.text)+pgShift
				pgEnd = Convert.ToInt32(pageEnd.text)+pgShift
				ViewState("PageNumber") = Convert.ToInt32(pgStart)
			ELSE
				pgStart = pageStart.text
				pgEnd = pageEnd.text
				ViewState("PageNumber") = Convert.ToInt32(pageCmd) - 1
			END IF 
		END IF 
		pageStart.text = pgStart
		pageEnd.text = pgEnd
		getResults()
	End Sub
	
    'Returns the record for editing to the text boxes on the form
    Protected Sub edtRecBtnClk(sender As Object, e As CommandEventArgs)
		srId=e.CommandArgument
        hideAll()
        infoParagraph.Style.Add("display","none")
        editSitRep.Style.Add("display", "block")
        fetchSitRep(srId)
		fetchSitRepCDS(srId)
		fetchSitRepCDM(srId)
		fetchSitRepRP(srId)
    End Sub
	
    Protected Sub fetchSitRep(e)
        myConnection.Open()
        cmd.Connection = myConnection
        fetchClause = "select *, case when SR_Time ='1' then 'Morning' when SR_Time ='2' then 'Midday' when SR_Time ='3' then 'Afternoon' when SR_Time ='4' then 'Evening' end as SR_Time_Text from DE_SitRep where SR_ID='" + e + "'"
        myDataAdapter = New SqlDataAdapter(fetchClause, myConnection)
        fetchResults = New DataSet()
        myDataAdapter.Fill(fetchResults)
        myConnection.Close()
        edtSR_ID.Text = fetchResults.Tables(0).Rows(0)("SR_ID").ToString()
        edtHosp.Text = fetchResults.Tables(0).Rows(0)("SR_Site").ToString()
        edtDate.Text = Left(fetchResults.Tables(0).Rows(0)("SR_Date").ToString(), 10)
        edtTime.Text = fetchResults.Tables(0).Rows(0)("SR_Time").ToString()
        edtTimeTxt.Text = fetchResults.Tables(0).Rows(0)("SR_Time_Text").ToString()
        '"Current Position" section 
        edtRisk.Text = fetchResults.Tables(0).Rows(0)("CP_Risk").ToString()
        edtEscalationLevel.Text = fetchResults.Tables(0).Rows(0)("CP_Escalation").ToString()
        edtTotalNumberInDepartment.Text = fetchResults.Tables(0).Rows(0)("CP_No_Dept").ToString()
        edtNumberWaitingBed.Text = fetchResults.Tables(0).Rows(0)("CP_Waiting").ToString()
        edtNumberOver12Hours.Text = fetchResults.Tables(0).Rows(0)("CP_Over_12").ToString()
        edtLongestWait.Text = fetchResults.Tables(0).Rows(0)("CP_Longest").ToString()
        edtOffloadSpaceMajor.Text = fetchResults.Tables(0).Rows(0)("CP_Off_Maj").ToString()
        edtOffloadSpaceMinor.Text = fetchResults.Tables(0).Rows(0)("CP_Off_Min").ToString()
        edtAmbulanceOutsideNow.Text = fetchResults.Tables(0).Rows(0)("CP_Amb_On").ToString()
        edtAmbulanceEnRoute.Text = fetchResults.Tables(0).Rows(0)("CP_Amb_En").ToString()
        edtITUCapacityToAdmit.Text = fetchResults.Tables(0).Rows(0)("CP_ITU_CTA").ToString()
        edtITUL1.Text = fetchResults.Tables(0).Rows(0)("CP_ITU_L1").ToString()
        edtITUL2.Text = fetchResults.Tables(0).Rows(0)("CP_ITU_L2").ToString()
        edtITUL3.Text = fetchResults.Tables(0).Rows(0)("CP_ITU_L3").ToString()
        edtCCU.Text = fetchResults.Tables(0).Rows(0)("CP_CCU").ToString()
        edtStroke.Text = fetchResults.Tables(0).Rows(0)("CP_Stroke").ToString()
        edtFractureNOF.Text = fetchResults.Tables(0).Rows(0)("CP_NOF").ToString()
        edtMedicallyOptimised.Text = fetchResults.Tables(0).Rows(0)("CP_MedOpt").ToString()
        edtMedicallyOptimisedTransfer.Text = fetchResults.Tables(0).Rows(0)("CP_MedOptRtT").ToString()
        edtOutliers.Text = fetchResults.Tables(0).Rows(0)("CP_Out").ToString()
        edtSurgicalBedsOpen.Text = fetchResults.Tables(0).Rows(0)("CP_Surge").ToString()
        edtElectiveCancellations.Text = fetchResults.Tables(0).Rows(0)("CP_El_Can").ToString()
        '"Other Information" section at bottom of form
        edtStaffingIssues.Text = fetchResults.Tables(0).Rows(0)("OI_Staffing").ToString()
        edtInfectionControlIssues.Text = fetchResults.Tables(0).Rows(0)("OI_Infection").ToString()
        edtAnyOtherIssues.Text = fetchResults.Tables(0).Rows(0)("OI_Other").ToString()
        edtSurgeBedsLocation.Text = fetchResults.Tables(0).Rows(0)("OI_Surge").ToString()
        edtOutlierBedsLocation.Text = fetchResults.Tables(0).Rows(0)("OI_Outlier").ToString()
		applyMatrixRisk()
		applyMatrixEL()
		edtRisk.Focus()
    End Sub
	
    Protected Sub fetchSitRepCDS(e)
        myConnection.Open()
        cmd.Connection = myConnection
        fetchClause = "select * from DE_SitRep_CapDem where SR_ID='" + e + "' and CD_Type='Surgical'"
        myDataAdapter = New SqlDataAdapter(fetchClause, myConnection)
        fetchResults = New DataSet()
        myDataAdapter.Fill(fetchResults)
        myConnection.Close()
        '"Demand & Capacity" section (Surgical)
        edtPredictionsAdmissionsSurgical.Text = fetchResults.Tables(0).Rows(0)("PD_PreAdm").ToString()
        edtOvernightersInAESurgical.Text = fetchResults.Tables(0).Rows(0)("PD_Overnight").ToString()
        edtCalcDaySurgical.Text = fetchResults.Tables(0).Rows(0)("PD_Calc_Day").ToString()
        edtAdmissionsSinceMidnightSurgical.Text = fetchResults.Tables(0).Rows(0)("PD_Adm").ToString()
        edtCalcAdmOutSurgical.Text = fetchResults.Tables(0).Rows(0)("PD_Calc_Adm_Out").ToString()
        edtUnplacedInAESurgical.Text = fetchResults.Tables(0).Rows(0)("AD_Unplaced").ToString()
        edtAmbicarePatientNeedingBedSurgical.Text = fetchResults.Tables(0).Rows(0)("AD_Ambicare").ToString()
        edtGPExpectedOutstandingSurgical.Text = fetchResults.Tables(0).Rows(0)("AD_GP").ToString()
        edtElectivesStillToBeAllocatedBedSurgical.Text = fetchResults.Tables(0).Rows(0)("AD_Elective").ToString()
        edtPlannedITUWardTransfersSurgical.Text = fetchResults.Tables(0).Rows(0)("AD_Planned").ToString()
        edtOfferedRepatsSurgical.Text = fetchResults.Tables(0).Rows(0)("AD_Offered").ToString()
        edtConversionSurgical.Text = fetchResults.Tables(0).Rows(0)("AD_Conversions").ToString()
        edtCalcDemandSurgical.Text = fetchResults.Tables(0).Rows(0)("AD_Calc_Demand").ToString()
        edtCurrentEmptyBedsSurgical.Text = fetchResults.Tables(0).Rows(0)("CA_Current").ToString()
        edtConfirmedDischargesSurgical.Text = fetchResults.Tables(0).Rows(0)("CA_Confirmed").ToString()
        edtQueryDischargesSurgical.Text = fetchResults.Tables(0).Rows(0)("CA_Query").ToString()
        edtCalcAvailabilitySurgical.Text = fetchResults.Tables(0).Rows(0)("CA_Calc_Availability").ToString()
        '"Predictions" section. These are all calculated fields within the database
        edtPreCalcBPSurgical.Text = fetchResults.Tables(0).Rows(0)("Pre_Calc_BP").ToString()
        edtPreCalcBPDNHSurgical.Text = fetchResults.Tables(0).Rows(0)("Pre_Calc_BP_DNH").ToString()
        edtPreCalcBASurgical.Text = fetchResults.Tables(0).Rows(0)("Pre_Calc_BA").ToString()
        edtPreCalcBADNHSurgical.Text = fetchResults.Tables(0).Rows(0)("Pre_Calc_BA_DNH").ToString()
    End Sub
	
    Protected Sub fetchSitRepCDM(e)
        myConnection.Open()
        cmd.Connection = myConnection
        fetchClause = "select * from DE_SitRep_CapDem where SR_ID='" + e + "' and CD_Type='Medical'"
        myDataAdapter = New SqlDataAdapter(fetchClause, myConnection)
        fetchResults = New DataSet()
        myDataAdapter.Fill(fetchResults)
        myConnection.Close()
        '"Demand & Capacity" section (Medical)
        edtPredictionsAdmissionsMedical.Text = fetchResults.Tables(0).Rows(0)("PD_PreAdm").ToString()
        edtOvernightersInAEMedical.Text = fetchResults.Tables(0).Rows(0)("PD_Overnight").ToString()
        edtCalcDayMedical.Text = fetchResults.Tables(0).Rows(0)("PD_Calc_Day").ToString()
        edtAdmissionsSinceMidnightMedical.Text = fetchResults.Tables(0).Rows(0)("PD_Adm").ToString()
        edtCalcAdmOutMedical.Text = fetchResults.Tables(0).Rows(0)("PD_Calc_Adm_Out").ToString()
        edtUnplacedInAEMedical.Text = fetchResults.Tables(0).Rows(0)("AD_Unplaced").ToString()
        edtAmbicarePatientNeedingBedMedical.Text = fetchResults.Tables(0).Rows(0)("AD_Ambicare").ToString()
        edtGPExpectedOutstandingMedical.Text = fetchResults.Tables(0).Rows(0)("AD_GP").ToString()
        edtElectivesStillToBeAllocatedBedMedical.Text = fetchResults.Tables(0).Rows(0)("AD_Elective").ToString()
        edtPlannedITUWardTransfersMedical.Text = fetchResults.Tables(0).Rows(0)("AD_Planned").ToString()
        edtOfferedRepatsMedical.Text = fetchResults.Tables(0).Rows(0)("AD_Offered").ToString()
        edtConversionMedical.Text = fetchResults.Tables(0).Rows(0)("AD_Conversions").ToString()
        edtCalcDemandMedical.Text = fetchResults.Tables(0).Rows(0)("AD_Calc_Demand").ToString()
        edtCurrentEmptyBedsMedical.Text = fetchResults.Tables(0).Rows(0)("CA_Current").ToString()
        edtConfirmedDischargesMedical.Text = fetchResults.Tables(0).Rows(0)("CA_Confirmed").ToString()
        edtQueryDischargesMedical.Text = fetchResults.Tables(0).Rows(0)("CA_Query").ToString()
        edtCalcAvailabilityMedical.Text = fetchResults.Tables(0).Rows(0)("CA_Calc_Availability").ToString()
        '"Predictions" section. These are all calculated fields within the database
        edtPreCalcBPMedical.Text = fetchResults.Tables(0).Rows(0)("Pre_Calc_BP").ToString()
        edtPreCalcBPDNHMedical.Text = fetchResults.Tables(0).Rows(0)("Pre_Calc_BP_DNH").ToString()
        edtPreCalcBAMedical.Text = fetchResults.Tables(0).Rows(0)("Pre_Calc_BA").ToString()
        edtPreCalcBADNHMedical.Text = fetchResults.Tables(0).Rows(0)("Pre_Calc_BA_DNH").ToString()
    End Sub
	
    Protected Sub fetchSitRepRP(e)
        myConnection.Open()
        cmd.Connection = myConnection
        fetchClause = "select * from DE_SitRep_Repats where SR_ID='" + e + "' and RP_Type = 'IN'"
        myDataAdapter = New SqlDataAdapter(fetchClause, myConnection)
        fetchTable = New DataTable()
        myDataAdapter.Fill(fetchTable)
		rePatsIn.DataSource = fetchTable
		rePatsIn.DataBind()
		Session("SdtPatIn") = fetchTable
        fetchClause = "select * from DE_SitRep_Repats where SR_ID='" + e + "' and RP_Type = 'OUT'"
        myDataAdapter = New SqlDataAdapter(fetchClause, myConnection)
        fetchTable = New DataTable()
        myDataAdapter.Fill(fetchTable)
		rePatsOut.DataSource = fetchTable
		rePatsOut.DataBind()
		Session("SdtPatOut") = fetchTable
        myConnection.Close()		
    End Sub
	
	Protected Sub applyMatrixRisk()
		matCheck = edtRisk.text
		edtRisk.Style.Add("background-color","white") 
		edtRisk.Style.Add("color","black") 
		if matCheck = 25 then 
			edtRisk.Style.Add("background-color","black") 
			edtRisk.Style.Add("color","white") 
		end if
		if matCheck = 20 then 
			edtRisk.Style.Add("background-color","red") 
			edtRisk.Style.Add("color","white") 
		end if
		if matCheck >= 12 and matCheck <= 16 then 
			edtRisk.Style.Add("background-color","gold") 
			edtRisk.Style.Add("color","black") 
		end if
		if matCheck >= 5 and matCheck <= 10 then 
			edtRisk.Style.Add("background-color","yellow") 
			edtRisk.Style.Add("color","black") 
		end if
		if matCheck >= 1 and matCheck <= 4 then 
			edtRisk.Style.Add("background-color","green") 
			edtRisk.Style.Add("color","white") 
		end if
		edtEscalationLevel.Focus()
	End Sub
	
	Protected Sub applyMatrixEL()
		matCheck = edtEscalationLevel.text
		edtEscalationLevel.Style.Add("background-color","white") 
		edtEscalationLevel.Style.Add("color","black") 
		if matCheck = 5 then 
			edtEscalationLevel.Style.Add("background-color","black") 
			edtEscalationLevel.Style.Add("color","white") 
		end if
		if matCheck = 4 then 
			edtEscalationLevel.Style.Add("background-color","red") 
			edtEscalationLevel.Style.Add("color","white") 
		end if
		if matCheck = 3 then 
			edtEscalationLevel.Style.Add("background-color","gold") 
			edtEscalationLevel.Style.Add("color","black") 
		end if
		if matCheck = 2 then 
			edtEscalationLevel.Style.Add("background-color","yellow") 
			edtEscalationLevel.Style.Add("color","black") 
		end if
		if matCheck = 1 then 
			edtEscalationLevel.Style.Add("background-color","green") 
			edtEscalationLevel.Style.Add("color","white") 
		end if
		edtTotalNumberInDepartment.Focus()
	End Sub
	
	Protected Sub calcPDSurg()
		DCPrAd = edtPredictionsAdmissionsSurgical.text
		DCOiAE = edtOvernightersInAESurgical.text
		DCAdmi = edtAdmissionsSinceMidnightSurgical.text
		if (NOT DCPrAd = "") and (NOT DCOiAE = "") and (NOT DCAdmi = "") then 
			edtCalcDaySurgical.text = CInt(DCPrAd)+CInt(DCOiAE)
			edtCalcAdmOutSurgical.text = CInt(edtCalcDaySurgical.text)-CInt(DCAdmi)
			edtUnplacedInAESurgical.Focus()
			calcPredSurg()
		End If
	End Sub
	
	Protected Sub calcPDMedi()
		DCPrAd = edtPredictionsAdmissionsMedical.text
		DCOiAE = edtOvernightersInAEMedical.text
		DCAdmi = edtAdmissionsSinceMidnightMedical.text
		if (NOT DCPrAd = "") and (NOT DCOiAE = "") and (NOT DCAdmi = "") then 
			edtCalcDayMedical.text = CInt(DCPrAd)+CInt(DCOiAE)
			edtCalcAdmOutMedical.text = CInt(edtCalcDayMedical.text)-CInt(DCAdmi)
			edtUnplacedInAEMedical.Focus()
			calcPredMedi()
		End If
	End Sub
	
	Protected Sub calcADSurg()
		ADUiAE = edtUnplacedInAESurgical.text
		ADAPNB = edtAmbicarePatientNeedingBedSurgical.text
		ADGPEO = edtGPExpectedOutstandingSurgical.text
		ADESAB = edtElectivesStillToBeAllocatedBedSurgical.text
		ADPIWT = edtPlannedITUWardTransfersSurgical.text
		ADOfRe = edtOfferedRepatsSurgical.text
		ADConv = edtConversionSurgical.text
		if (NOT ADUiAE = "") and (NOT ADAPNB = "") and (NOT ADGPEO = "") and (NOT ADESAB = "") and (NOT ADPIWT = "") and (NOT ADOfRe = "") and (NOT ADConv = "") then 
			edtCalcDemandSurgical.text = CInt(ADUiAE)+CInt(ADAPNB)+CInt(ADGPEO)+CInt(ADESAB)+CInt(ADPIWT)+CInt(ADOfRe)+CInt(ADConv)
			edtCurrentEmptyBedsSurgical.Focus()
			calcPredSurg()
		End If
	End Sub
	
	Protected Sub calcADMedi()
		ADUiAE = edtUnplacedInAEMedical.text
		ADAPNB = edtAmbicarePatientNeedingBedMedical.text
		ADGPEO = edtGPExpectedOutstandingMedical.text
		ADESAB = edtElectivesStillToBeAllocatedBedMedical.text
		ADPIWT = edtPlannedITUWardTransfersMedical.text
		ADOfRe = edtOfferedRepatsMedical.text
		ADConv = edtConversionMedical.text
		if (NOT ADUiAE = "") and (NOT ADAPNB = "") and (NOT ADGPEO = "") and (NOT ADESAB = "") and (NOT ADPIWT = "") and (NOT ADOfRe = "") and (NOT ADConv = "") then 
			edtCalcDemandMedical.text = CInt(ADUiAE)+CInt(ADAPNB)+CInt(ADGPEO)+CInt(ADESAB)+CInt(ADPIWT)+CInt(ADOfRe)+CInt(ADConv)
			edtCurrentEmptyBedsMedical.Focus()
			calcPredMedi()
		End If
	End Sub
	
	Protected Sub calcCaSurg()
		CaCuED = edtCurrentEmptyBedsSurgical.text
		CaCoDi = edtConfirmedDischargesSurgical.text
		CaQuDi = edtQueryDischargesSurgical.text
		if (NOT CaCuED = "") and (NOT CaCoDi = "") and (NOT CaQuDi = "") then 
			edtCalcAvailabilitySurgical.text = CInt(CaCuED)+CInt(CaCoDi)+CInt(CaQuDi)
			txtRepatsValue.Focus()
			calcPredSurg()
		End If
	End Sub
	
	Protected Sub calcCaMedi()
		CaCuED = edtCurrentEmptyBedsMedical.text
		CaCoDi = edtConfirmedDischargesMedical.text
		CaQuDi = edtQueryDischargesMedical.text
		if (NOT CaCuED = "") and (NOT CaCoDi = "") and (NOT CaQuDi = "") then 
			edtCalcAvailabilityMedical.text = CInt(CaCuED)+CInt(CaCoDi)+CInt(CaQuDi)
			txtRepatsValue.Focus()
			calcPredMedi()
		End If
	End Sub
	
	Protected Sub calcPredSurg()
		' Balance on Prediction
		PreInt = CInt(edtCalcAvailabilitySurgical.text)
		PreInt = PreInt-CInt(edtCalcAdmOutSurgical.text)
		PreInt = PreInt-CInt(edtAmbicarePatientNeedingBedSurgical.text)
		PreInt = PreInt-CInt(edtElectivesStillToBeAllocatedBedSurgical.text)
		edtPreCalcBPSurgical.text = Cstr(PreInt)
		' BOP if queries do not happen
		PreInt = PreInt-CInt(edtQueryDischargesSurgical.text)
		edtPreCalcBPDNHSurgical.text = Cstr(PreInt)
		' Balance on Actual
		PreInt = CInt(edtCalcAvailabilitySurgical.text)
		PreInt = PreInt-CInt(edtCalcDemandSurgical.text)
		edtPreCalcBASurgical.text = Cstr(PreInt)
		' BOA if queries do not happen
		PreInt = PreInt-CInt(edtQueryDischargesSurgical.text)
		edtPreCalcBADNHSurgical.text = Cstr(PreInt)
	End Sub
	
	Protected Sub calcPredMedi()
		' Balance on Prediction
		PreInt = CInt(edtCalcAvailabilityMedical.text)
		PreInt = PreInt-CInt(edtCalcAdmOutMedical.text)
		PreInt = PreInt-CInt(edtAmbicarePatientNeedingBedMedical.text)
		PreInt = PreInt-CInt(edtElectivesStillToBeAllocatedBedMedical.text)
		edtPreCalcBPMedical.text = Cstr(PreInt)
		' BOP if queries do not happen
		PreInt = PreInt-CInt(edtQueryDischargesMedical.text)
		edtPreCalcBPDNHMedical.text = Cstr(PreInt)
		' Balance on Actual
		PreInt = CInt(edtCalcAvailabilityMedical.text)
		PreInt = PreInt-CInt(edtCalcDemandMedical.text)
		edtPreCalcBAMedical.text = Cstr(PreInt)
		' BOA if queries do not happen
		PreInt = PreInt-CInt(edtQueryDischargesMedical.text)
		edtPreCalcBADNHMedical.text = Cstr(PreInt)
	End Sub
	
	Protected Sub DelRPin(sender As Object, e As EventArgs)
        DelID = (CType(sender, LinkButton).CommandArgument).ToString
		Dim tIn As DataTable = DirectCast(Session("SdtPatIn"), DataTable) 
		For Each row As DataRow In tIn.Select()
			If row("RP_ID") = DelID Then
				row.Delete()
				Session("dtIn") = tIn
				rePatsIn.DataSource = tIn
				rePatsIn.DataBind()
			End If
		Next
		RPFocus()
	End Sub
	
	Protected Sub DelRPout(sender As Object, e As EventArgs)
        DelID = (CType(sender, LinkButton).CommandArgument).ToString
		Dim tOut As DataTable = DirectCast(Session("SdtPatOut"), DataTable) 
		For Each row As DataRow In tOut.Select()
			If row("RP_ID") = DelID Then
				row.Delete()
				Session("dtOut") = tOut
				rePatsOut.DataSource = tOut
				rePatsOut.DataBind()
			End If
		Next
		RPFocus()
	End Sub
	
	Protected Sub addRepats()
		if (NOT txtRepatsValue.text = "") then
			Session("sRID") = Session("sRID")+1
			if rbllRepatsType.SelectedItem.value = "IN" Then
				Dim tIn As DataTable = DirectCast(Session("SdtPatIn"), DataTable) 
				Dim rowIn As DataRow = tIn.NewRow() 
				rowIn("RP_ID") = Session("sRID")
				rowIn("RP_Type") = rbllRepatsType.SelectedItem.value
				rowIn("RP_Text") = txtRepatsValue.text 
				tIn.Rows.Add(rowIn) 
				Session("dtIn") = tIn
				rePatsIn.DataSource = tIn
				rePatsIn.DataBind()
			else
				Dim tOut As DataTable = DirectCast(Session("SdtPatOut"), DataTable) 
				Dim rowOut As DataRow = tOut.NewRow() 
				rowOut("RP_ID") = Session("sRID")
				rowOut("RP_Type") = rbllRepatsType.SelectedItem.value
				rowOut("RP_Text") = txtRepatsValue.text 
				tOut.Rows.Add(rowOut) 
				Session("dtOut") = tOut
				rePatsOut.DataSource = tOut
				rePatsOut.DataBind()
			End if
			txtRepatsValue.text = ""
			RPFocus()
		End If
	End Sub
	
	Protected Sub RPFocus()
		txtRepatsValue.Focus()
	End Sub
	
    'Update the record
    Protected Sub edtRecBTN()
        myConnection.Open()
        cmd.Connection = myConnection
        'SQL update command - DE_SitRep
        cmdText = "UPDATE DE_SitRep SET CP_Risk='" + edtRisk.Text + "'" &
        ", CP_Escalation='" + edtEscalationLevel.Text + "'" &
        ", CP_No_Dept='" + edtTotalNumberInDepartment.Text + "'" &
        ", CP_Waiting='" + edtNumberWaitingBed.Text + "'" &
        ", CP_Over_12='" + edtNumberOver12Hours.Text + "'" &
        ", CP_Longest='" + edtLongestWait.Text + "'" &
        ", CP_Off_Maj='" + edtOffloadSpaceMajor.Text + "'" &
        ", CP_Off_Min='" + edtOffloadSpaceMinor.Text + "'" &
        ", CP_Amb_On='" + edtAmbulanceOutsideNow.Text + "'" &
        ", CP_Amb_En='" + edtAmbulanceEnRoute.Text + "'" &
        ", CP_ITU_CTA='" + edtITUCapacityToAdmit.Text + "'" &
        ", CP_ITU_L1='" + edtITUL1.Text + "'" &
        ", CP_ITU_L2='" + edtITUL2.Text + "'" &
        ", CP_ITU_L3='" + edtITUL3.Text + "'" &
        ", CP_CCU='" + edtCCU.Text + "'" &
        ", CP_Stroke='" + edtStroke.Text + "'" &
        ", CP_NOF='" + edtFractureNOF.Text + "'" &
        ", CP_MedOpt='" + edtMedicallyOptimised.Text + "'" &
        ", CP_MedOptRtT='" + edtMedicallyOptimisedTransfer.Text + "'" &
        ", CP_Out='" + edtOutliers.Text + "'" &
        ", CP_Surge='" + edtSurgicalBedsOpen.Text + "'" &
        ", CP_El_Can='" + edtElectiveCancellations.Text + "'" &
        ", OI_Staffing='" + edtStaffingIssues.Text + "'" &
        ", OI_Infection='" + edtInfectionControlIssues.Text + "'" &
        ", OI_Other='" + edtAnyOtherIssues.Text + "'" &
        ", OI_Surge='" + edtSurgeBedsLocation.Text + "'" &
        ", OI_Outlier='" + edtOutlierBedsLocation.Text + "'" &
        ", SR_ModUser='" + HttpContext.Current.User.Identity.Name.ToString() + "'" &
        ", SR_ModDate=GETDATE() where SR_ID='" + edtSR_ID.text + "'"	
		cmd.CommandText = cmdText
		cmd.ExecuteNonQuery()
        'SQL update command - DE_SitRep_CapDem
		'Surgical
        cmdText = "UPDATE DE_SitRep_CapDem SET PD_PreAdm='" + edtPredictionsAdmissionsSurgical.Text + "'" &
        ", PD_Overnight='" + edtOvernightersInAESurgical.Text + "'" & 
        ", PD_Calc_Day='" + edtCalcDaySurgical.text + "'" &
	    ", PD_Adm='" + edtAdmissionsSinceMidnightSurgical.Text + "'" &
	    ", PD_Calc_Adm_Out='" + edtCalcAdmOutSurgical.text + "'" & 
	    ", AD_Unplaced='" + edtUnplacedInAESurgical.Text + "'" & 
	    ", AD_Ambicare='" + edtAmbicarePatientNeedingBedSurgical.Text + "'" & 
	    ", AD_GP='" + edtGPExpectedOutstandingSurgical.Text + "'" &  
	    ", AD_Elective='" + edtElectivesStillToBeAllocatedBedSurgical.Text + "'" & 
	    ", AD_Planned='" + edtPlannedITUWardTransfersSurgical.Text + "'" & 
	    ", AD_Offered='" + edtOfferedRepatsSurgical.Text + "'" & 
	    ", AD_Conversions='" + edtConversionSurgical.Text + "'" & 
	    ", AD_Calc_Demand='" + edtCalcDemandSurgical.text + "'" &
	    ", CA_Current='" + edtCurrentEmptyBedsSurgical.Text + "'" &  
	    ", CA_Confirmed='" + edtConfirmedDischargesSurgical.Text + "'" & 
	    ", CA_Query='" + edtQueryDischargesSurgical.Text + "'" &  
	    ", CA_Calc_Availability='" + edtCalcAvailabilitySurgical.text + "'" & 
        ", Pre_Calc_BP='" +  edtPreCalcBPSurgical.text + "'" & 
        ", Pre_Calc_BP_DNH='" + edtPreCalcBPDNHSurgical.text + "'" &
        ", Pre_Calc_BA='" + edtPreCalcBASurgical.text + "'" & 
        ", Pre_Calc_BA_DNH='" + edtPreCalcBADNHSurgical.text + "'" &
        "  where SR_ID='" + edtSR_ID.text + "' and CD_Type='Surgical'"
		cmd.CommandText = cmdText
		cmd.ExecuteNonQuery()
		'Medical
        cmdText = "UPDATE DE_SitRep_CapDem SET PD_PreAdm='" + edtPredictionsAdmissionsMedical.Text + "'" &
        ", PD_Overnight='" + edtOvernightersInAEMedical.Text + "'" & 
        ", PD_Calc_Day='" + edtCalcDayMedical.text + "'" &
	    ", PD_Adm='" + edtAdmissionsSinceMidnightMedical.Text + "'" &
	    ", PD_Calc_Adm_Out='" + edtCalcAdmOutMedical.text + "'" & 
	    ", AD_Unplaced='" + edtUnplacedInAEMedical.Text + "'" & 
	    ", AD_Ambicare='" + edtAmbicarePatientNeedingBedMedical.Text + "'" & 
	    ", AD_GP='" + edtGPExpectedOutstandingMedical.Text + "'" &  
	    ", AD_Elective='" + edtElectivesStillToBeAllocatedBedMedical.Text + "'" & 
	    ", AD_Planned='" + edtPlannedITUWardTransfersMedical.Text + "'" & 
	    ", AD_Offered='" + edtOfferedRepatsMedical.Text + "'" & 
	    ", AD_Conversions='" + edtConversionMedical.Text + "'" & 
	    ", AD_Calc_Demand='" + edtCalcDemandMedical.text + "'" &
	    ", CA_Current='" + edtCurrentEmptyBedsMedical.Text + "'" &  
	    ", CA_Confirmed='" + edtConfirmedDischargesMedical.Text + "'" & 
	    ", CA_Query='" + edtQueryDischargesMedical.Text + "'" &  
	    ", CA_Calc_Availability='" + edtCalcAvailabilityMedical.text + "'" & 
        ", Pre_Calc_BP='" +  edtPreCalcBPMedical.text + "'" & 
        ", Pre_Calc_BP_DNH='" + edtPreCalcBPDNHMedical.text + "'" &
        ", Pre_Calc_BA='" + edtPreCalcBAMedical.text + "'" & 
        ", Pre_Calc_BA_DNH='" + edtPreCalcBADNHMedical.text + "'" &
        "  where SR_ID='" + edtSR_ID.text + "' and CD_Type='Medical'"
		cmd.CommandText = cmdText
		cmd.ExecuteNonQuery()
        'SQL Delete and Insert command - DE_SitRep_Repats
		'Delete Repats for this SR_ID to re-insert
        cmdText = "Delete from DE_SitRep_Repats where SR_ID = '" + edtSR_ID.text + "'"	
		cmd.CommandText = cmdText
		cmd.ExecuteNonQuery()
		'Insert the Repats "Coming In"
		Dim tIn As DataTable = DirectCast(Session("SdtPatIn"), DataTable) 
		For Each row As DataRow In tIn.Select()
			cmdText = "INSERT INTO DE_SitRep_Repats values("& edtSR_ID.text &",'"& row("RP_Type") &"','"& row("RP_Text") &"')"
			cmd.CommandText = cmdText
			cmd.ExecuteNonQuery()
		Next
		'Insert the Repats "Going Out"
		Dim tOut As DataTable = DirectCast(Session("SdtPatOut"), DataTable) 
		For Each row As DataRow In tOut.Select()
			cmdText = "INSERT INTO DE_SitRep_Repats values("& edtSR_ID.text &",'"& row("RP_Type") &"','"& row("RP_Text") &"')"
			cmd.CommandText = cmdText
			cmd.ExecuteNonQuery()
		Next
        myConnection.Close()
        resetPaging()
        getResults()
    End Sub
	
	Protected Sub cancelBTN()
		hideAll()
		editSummary.Style.Add("display","block")
        infoParagraph.Style.Add("display","block")
		getRecords()
	End Sub
 
End Class
