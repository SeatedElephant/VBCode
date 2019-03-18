Imports System
Imports System.IO
Imports System.Web.UI
Imports System.Web
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.UI.WebControls

Partial Class SitRepInput
    Inherits System.Web.UI.Page

	Dim myConnection As SqlConnection = New SqlConnection(ConfigurationManager.ConnectionStrings("cn_IRIS").ConnectionString)
	Dim cmd As New SqlCommand
	Dim theDate As String
	Dim dupYesNo
	Dim maxSRID As Integer
	Dim dtPatIn As DataTable
	Dim dtPatOut As DataTable
	Dim rpStr As String
	Dim DelID As String
	Dim rowID As Integer = 0
	Dim rpSql As String
	Dim matCheck as Integer

	Sub Page_Load(sender As Object, e As EventArgs) Handles MyBase.Load
		If Not IsPostBack 
			txtTheDate.text = Today
			buildRepats()
		End If
	End Sub
	
	'Check for duplicates before with the same Site, Date, and Time. If they exist warn user. If not make the submission and report succes
	Protected Sub checkIfDuplicate()
		myConnection.open()
		cmd.Connection = myConnection
		
		'Needed so that the date is input in the DB in correct format
		theDate = Right(txtTheDate.text, 4) + Mid(txtTheDate.text, 4, 2) + Left(txtTheDate.text, 2)

		cmd.CommandText = "IF NOT EXISTS (SELECT * FROM DE_SitRep WHERE SR_Site=@SR_Site and SR_Date=@SR_Date and SR_Time=@SR_Time) SELECT 0 ELSE  SELECT 1"
		cmd.Parameters.AddWithValue("@SR_Site", ddlHospitalInitials.text)
		cmd.Parameters.AddWithValue("@SR_Date", theDate)
		cmd.Parameters.AddWithValue("@SR_Time", ddlTheTime.text)
		dupYesNo = cmd.ExecuteScalar

		Session("Svar") = dupYesNo

		lblUserMessage.text = ""
		If dupYesNo = 0 Then
			submit
		else lblUserMessage.text = "WARNING: Record NOT submitted. SitRep data for that hospital, date and time already submitted."
		end if 

		cmd.Connection.Close()
	End Sub
	
	Protected Sub applyMatrixRisk()
		matCheck = txtRisk.text
		txtRisk.Style.Add("background-color","white") 
		txtRisk.Style.Add("color","black") 
		if matCheck = 25 then 
			txtRisk.Style.Add("background-color","black") 
			txtRisk.Style.Add("color","white") 
		end if
		if matCheck = 20 then 
			txtRisk.Style.Add("background-color","red") 
			txtRisk.Style.Add("color","white") 
		end if
		if matCheck >= 12 and matCheck <= 16 then 
			txtRisk.Style.Add("background-color","gold") 
			txtRisk.Style.Add("color","black") 
		end if
		if matCheck >= 5 and matCheck <= 10 then 
			txtRisk.Style.Add("background-color","yellow") 
			txtRisk.Style.Add("color","black") 
		end if
		if matCheck >= 1 and matCheck <= 4 then 
			txtRisk.Style.Add("background-color","green") 
			txtRisk.Style.Add("color","white") 
		end if
		txtEscalationLevel.Focus()
	End Sub
	
	Protected Sub applyMatrixEL()
		matCheck = txtEscalationLevel.text
		txtEscalationLevel.Style.Add("background-color","white") 
		txtEscalationLevel.Style.Add("color","black") 
		if matCheck = 5 then 
			txtEscalationLevel.Style.Add("background-color","black") 
			txtEscalationLevel.Style.Add("color","white") 
		end if
		if matCheck = 4 then 
			txtEscalationLevel.Style.Add("background-color","red") 
			txtEscalationLevel.Style.Add("color","white") 
		end if
		if matCheck = 3 then 
			txtEscalationLevel.Style.Add("background-color","gold") 
			txtEscalationLevel.Style.Add("color","black") 
		end if
		if matCheck = 2 then 
			txtEscalationLevel.Style.Add("background-color","yellow") 
			txtEscalationLevel.Style.Add("color","black") 
		end if
		if matCheck = 1 then 
			txtEscalationLevel.Style.Add("background-color","green") 
			txtEscalationLevel.Style.Add("color","white") 
		end if
		txtTotalNumberInDepartment.Focus()
	End Sub
		
	Protected Sub confirmSubmit()
		'need to check for duplicates again in case the user has used the back button from a successfully submission, session variable stores the
		'duplicates check value between pages
		checkIfDuplicate

		If Session("Svar") =  0 then
			myConnection.open()
			cmd.Connection = myConnection

			'Needed so that the date is input in the DB in correct format
			theDate = Right(txtTheDate.text, 4) + Mid(txtTheDate.text, 4, 2) + Left(txtTheDate.text, 2)

			'Insert main table, will generate the SR_ID we will use for the subsequent inserts
			cmd.CommandText = "INSERT INTO [App_IRIS].[dbo].[DE_SitRep] VALUES (" &
			"  @iSR_Site" &
			", @iSR_Date" &
			", @iSR_Time" &
			", @iCP_Risk" &
			", @iCP_Escalation" &
			", @iCP_No_Dept" &
			", @iCP_Waiting" &
			", @iCP_Over_12" &
			", @iCP_Longest" &
			", @iCP_Off_Maj" &
			", @iCP_Off_Min" &
			", @iCP_Amb_On" &
			", @iCP_Amb_En" &
			", @iCP_ITU_CTA" &
			", @iCP_ITU_L1" &
			", @iCP_ITU_L2" &
			", @iCP_ITU_L3" &
			", @iCP_CCU" &
			", @iCP_Stroke" &
			", @iCP_NOF" &
			", @iCP_MedOpt" &
			", @iCP_MedOptRtT" &
			", @iCP_Out" &
			", @iCP_Surge" &
			", @iCP_El_Can" &
			", @iOI_Staffing" &
			", @iOI_Infection" &
			", @iOI_Other" &
			", @iOI_Surge" &
			", @iOI_Outlier" &
			", @iSR_Status" &
			", @iSR_ModDate" &
			", @iSR_ModUser" &
			")"
			cmd.Parameters.AddWithValue("@iSR_Site", lblHospitalInitials.text)
			cmd.Parameters.AddWithValue("@iSR_Date", DateTime.Parse(lblTheDate.text))
			cmd.Parameters.AddWithValue("@iSR_Time", lblTheTime.text)
			cmd.Parameters.AddWithValue("@iCP_Risk", lblRisk.text)
			cmd.Parameters.AddWithValue("@iCP_Escalation", lblEscalationLevel.text)
			cmd.Parameters.AddWithValue("@iCP_No_Dept", lblTotalNumberInDepartment.text)
			cmd.Parameters.AddWithValue("@iCP_Waiting", lblNumberWaitingBed.text)
			cmd.Parameters.AddWithValue("@iCP_Over_12", lblNumberOver12Hours.text)
			cmd.Parameters.AddWithValue("@iCP_Longest", lblLongestWait.text)
			cmd.Parameters.AddWithValue("@iCP_Off_Maj", lblOffloadSpaceMajor.text)
			cmd.Parameters.AddWithValue("@iCP_Off_Min", lblOffloadSpaceMinor.text) 
			cmd.Parameters.AddWithValue("@iCP_Amb_On", lblAmbulanceOutsideNow.text)
			cmd.Parameters.AddWithValue("@iCP_Amb_En", lblAmbulanceEnRoute.text) 
			cmd.Parameters.AddWithValue("@iCP_ITU_CTA", lblITUCapacityToAdmit.text)
			cmd.Parameters.AddWithValue("@iCP_ITU_L1", lblITUL1.text)
			cmd.Parameters.AddWithValue("@iCP_ITU_L2", lblITUL2.text) 
			cmd.Parameters.AddWithValue("@iCP_ITU_L3", lblITUL3.text)
			cmd.Parameters.AddWithValue("@iCP_CCU", lblCCU.text)
			cmd.Parameters.AddWithValue("@iCP_Stroke", lblStroke.text)
			cmd.Parameters.AddWithValue("@iCP_NOF", lblFractureNOF.text)
			cmd.Parameters.AddWithValue("@iCP_MedOpt", lblMedicallyOptimised.Text)
			cmd.Parameters.AddWithValue("@iCP_MedOptRtT", lblMedicallyOptimisedTransfer.text)
			cmd.Parameters.AddWithValue("@iCP_Out", lblOutliers.text)
			cmd.Parameters.AddWithValue("@iCP_Surge", lblSurgicalBedsOpen.text)
			cmd.Parameters.AddWithValue("@iCP_El_Can", lblElectiveCancellations.text) 
			cmd.Parameters.AddWithValue("@iOI_Staffing", lblStaffingIssues.text)   
			cmd.Parameters.AddWithValue("@iOI_Infection", lblInfectionControlIssues.text) 
			cmd.Parameters.AddWithValue("@iOI_Other", lblAnyOtherIssues.text)
			cmd.Parameters.AddWithValue("@iOI_Surge", lblSurgeBedsLocation.text)
			cmd.Parameters.AddWithValue("@iOI_Outlier", lblOutlierBedsLocation.text)
			cmd.Parameters.AddWithValue("@iSR_Status", "")
			cmd.Parameters.AddWithValue("@iSR_ModDate", Now) 
			cmd.Parameters.AddWithValue("@iSR_ModUser", User.Identity.Name)
			cmd.ExecuteNonQuery()

			'Get the latest SR_ID to use in the next table inserts
			cmd.CommandText = "SELECT MAX(SR_ID) FROM [App_IRIS].[dbo].[DE_SitRep]"
			maxSRID = cmd.ExecuteScalar

			'Insert Surgical Type
			cmd.CommandText = "INSERT INTO [App_IRIS].[dbo].[DE_SitRep_CapDem] VALUES (" & _
			"  @sSR_ID" & _
			", @sCD_Type" & _
			", @sPD_PreAdm" & _ 
			", @sPD_Overnight" & _
			", @sPD_Calc_Day" & _
			", @sPD_Adm" & _
			", @sPD_Calc_Adm_Out" & _
			", @sAD_Unplaced" & _ 
			", @sAD_Ambicare" & _ 
			", @sAD_GP" & _  
			", @sAD_Elective" & _ 
			", @sAD_Planned" & _ 
			", @sAD_Offered" & _ 
			", @sAD_Conversions" & _ 
			", @sAD_Calc_Demand" & _
			", @sCA_Current" & _ 
			", @sCA_Confirmed" & _ 
			", @sCA_Query" & _
			", @sCA_Calc_Availability" & _ 
			", @sPre_Calc_BP" & _ 
			", @sPre_Calc_BP_DNH" & _
			", @sPre_Calc_BA" & _ 
			", @sPre_Calc_BA_DNH" & _ 
			")"
			cmd.Parameters.AddWithValue("@sSR_ID", maxSRID)
			cmd.Parameters.AddWithValue("@sCD_Type", "Surgical")
			cmd.Parameters.AddWithValue("@sPD_PreAdm", lblPredictionsAdmissionsSurgical.text)
			cmd.Parameters.AddWithValue("@sPD_Overnight", lblOvernightersInAESurgical.text)
			cmd.Parameters.AddWithValue("@sPD_Calc_Day", lblCalcDaySurgical.text)
			cmd.Parameters.AddWithValue("@sPD_Adm", lblAdmissionsSinceMidnightSurgical.text)
			cmd.Parameters.AddWithValue("@sPD_Calc_Adm_Out", lblCalcAdmOutSurgical.text)
			cmd.Parameters.AddWithValue("@sAD_Unplaced", lblUnplacedInAESurgical.text) 
			cmd.Parameters.AddWithValue("@sAD_Ambicare", lblAmbicarePatientNeedingBedSurgical.text) 
			cmd.Parameters.AddWithValue("@sAD_GP", lblGPExpectedOutstandingSurgical.text)  
			cmd.Parameters.AddWithValue("@sAD_Elective", lblElectivesStillToBeAllocatedBedSurgical.text) 
			cmd.Parameters.AddWithValue("@sAD_Planned", lblPlannedITUWardTransfersSurgical.text) 
			cmd.Parameters.AddWithValue("@sAD_Offered", lblOfferedRepatsSurgical.text) 
			cmd.Parameters.AddWithValue("@sAD_Conversions", lblConversionSurgical.text) 
			cmd.Parameters.AddWithValue("@sAD_Calc_Demand", lblCalcDemandSurgical.text)
			cmd.Parameters.AddWithValue("@sCA_Current", lblCurrentEmptyBedsSurgical.text) 
			cmd.Parameters.AddWithValue("@sCA_Confirmed", lblConfirmedDischargesSurgical.text) 
			cmd.Parameters.AddWithValue("@sCA_Query", lblQueryDischargesSurgical.text)  
			cmd.Parameters.AddWithValue("@sCA_Calc_Availability", lblCalcAvailabilitySurgical.text)
			cmd.Parameters.AddWithValue("@sPre_Calc_BP", lblPreCalcBPSurgical.text)
			cmd.Parameters.AddWithValue("@sPre_Calc_BP_DNH", lblPreCalcBPDNHSurgical.text)
			cmd.Parameters.AddWithValue("@sPre_Calc_BA", lblPreCalcBASurgical.text)
			cmd.Parameters.AddWithValue("@sPre_Calc_BA_DNH", lblPreCalcBADNHSurgical.text)
			cmd.ExecuteNonQuery()

			'Insert Medical Type
			cmd.CommandText = "INSERT INTO [App_IRIS].[dbo].[DE_SitRep_CapDem] VALUES (" & _
			"  @mSR_ID" & _
			", @mCD_Type" & _
			", @mPD_PreAdm" & _ 
			", @mPD_Overnight" & _
			", @mPD_Calc_Day" & _
			", @mPD_Adm" & _
			", @mPD_Calc_Adm_Out" & _
			", @mAD_Unplaced" & _ 
			", @mAD_Ambicare" & _ 
			", @mAD_GP" & _  
			", @mAD_Elective" & _ 
			", @mAD_Planned" & _ 
			", @mAD_Offered" & _ 
			", @mAD_Conversions" & _ 
			", @mAD_Calc_Demand" & _
			", @mCA_Current" & _ 
			", @mCA_Confirmed" & _ 
			", @mCA_Query" & _
			", @mCA_Calc_Availability" & _ 
			", @mPre_Calc_BP" & _ 
			", @mPre_Calc_BP_DNH" & _
			", @mPre_Calc_BA" & _ 
			", @mPre_Calc_BA_DNH" & _ 
			")"
			cmd.Parameters.AddWithValue("@mSR_ID", maxSRID)
			cmd.Parameters.AddWithValue("@mCD_Type", "Medical")
			cmd.Parameters.AddWithValue("@mPD_PreAdm", lblPredictionsAdmissionsMedical.text)
			cmd.Parameters.AddWithValue("@mPD_Overnight", lblOvernightersInAEMedical.text)
			cmd.Parameters.AddWithValue("@mPD_Calc_Day", lblCalcDayMedical.text)
			cmd.Parameters.AddWithValue("@mPD_Adm", lblAdmissionsSinceMidnightMedical.text)
			cmd.Parameters.AddWithValue("@mPD_Calc_Adm_Out", lblCalcAdmOutMedical.text)
			cmd.Parameters.AddWithValue("@mAD_Unplaced", lblUnplacedInAEMedical.text) 
			cmd.Parameters.AddWithValue("@mAD_Ambicare", lblAmbicarePatientNeedingBedMedical.text) 
			cmd.Parameters.AddWithValue("@mAD_GP", lblGPExpectedOutstandingMedical.text)  
			cmd.Parameters.AddWithValue("@mAD_Elective", lblElectivesStillToBeAllocatedBedMedical.text) 
			cmd.Parameters.AddWithValue("@mAD_Planned", lblPlannedITUWardTransfersMedical.text) 
			cmd.Parameters.AddWithValue("@mAD_Offered", lblOfferedRepatsMedical.text) 
			cmd.Parameters.AddWithValue("@mAD_Conversions", lblConversionMedical.text) 
			cmd.Parameters.AddWithValue("@mAD_Calc_Demand", lblCalcDemandMedical.text)
			cmd.Parameters.AddWithValue("@mCA_Current", lblCurrentEmptyBedsMedical.text) 
			cmd.Parameters.AddWithValue("@mCA_Confirmed", lblConfirmedDischargesMedical.text) 
			cmd.Parameters.AddWithValue("@mCA_Query", lblQueryDischargesMedical.text)  
			cmd.Parameters.AddWithValue("@mCA_Calc_Availability", lblCalcAvailabilityMedical.text)
			cmd.Parameters.AddWithValue("@mPre_Calc_BP", lblPreCalcBPMedical.text)
			cmd.Parameters.AddWithValue("@mPre_Calc_BP_DNH", lblPreCalcBPDNHMedical.text)
			cmd.Parameters.AddWithValue("@mPre_Calc_BA", lblPreCalcBAMedical.text)
			cmd.Parameters.AddWithValue("@mPre_Calc_BA_DNH", lblPreCalcBADNHMedical.text) 
			cmd.ExecuteNonQuery()
			
			'Insert the Repats "Coming In"
			Dim tIn As DataTable = DirectCast(Session("SdtPatIn"), DataTable) 
			For Each row As DataRow In tIn.Select()
				rpSql = "INSERT INTO DE_SitRep_Repats values("& maxSRID &",'"& row("RP_Type") &"','"& row("RP_Value") &"')"
				cmd.CommandText = rpSql
				cmd.ExecuteNonQuery()
			Next
			
			'Insert the Repats "Going Out"
			Dim tOut As DataTable = DirectCast(Session("SdtPatOut"), DataTable) 
			For Each row As DataRow In tOut.Select()
				rpSql = "INSERT INTO DE_SitRep_Repats values("& maxSRID &",'"& row("RP_Type") &"','"& row("RP_Value") &"')"
				cmd.CommandText = rpSql
				cmd.ExecuteNonQuery()
			Next
			
			myConnection.Close()
			
			'hide the sitConfirm DIV and display success message
			sitConfirm.Style.Add("display","none")
			infoParagraph.Style.Add("display","none")
			lblUserMessage.text = "SitRep submitted successfully."
		End If
	End Sub

	Protected Sub submit()
		'Display the confirmation/labels DIV and hide the input/textbox DIV
		sitMain.Style.Add("display","none")
		infoParagraph.Style.Add("display","none")
		sitConfirm.Style.Add("display","block")

		'Populate the confirmation labels from the textboxes values entered
		lblHospitalInitials.Text = ddlHospitalInitials.Text
		lblTheDate.Text = txtTheDate.Text
		lblTheTime.Text =  ddlTheTime.Text
		lblRisk.Text = txtRisk.Text
		lblEscalationLevel.Text = txtEscalationLevel.Text
		lblTotalNumberInDepartment.Text = txtTotalNumberInDepartment.Text
		lblNumberWaitingBed.Text = txtNumberWaitingBed.Text
		lblNumberOver12Hours.Text = txtNumberOver12Hours.Text
		lblLongestWait.Text = txtLongestWait.Text
		lblOffloadSpaceMajor.Text = txtOffloadSpaceMajor.Text
		lblOffloadSpaceMinor.Text = txtOffloadSpaceMinor.Text 
		lblAmbulanceOutsideNow.Text = txtAmbulanceOutsideNow.Text
		lblAmbulanceEnRoute.Text = txtAmbulanceEnRoute.Text
		lblITUCapacityToAdmit.Text = txtITUCapacityToAdmit.Text
		lblITUL1.Text = txtITUL1.Text
		lblITUL2.Text = txtITUL2.Text 
		lblITUL3.Text = txtITUL3.Text
		lblCCU.Text = txtCCU.Text
		lblStroke.Text = txtStroke.Text
		lblFractureNOF.Text = txtFractureNOF.Text
		lblMedicallyOptimised.Text = txtMedicallyOptimised.Text
		lblMedicallyOptimisedTransfer.Text = txtMedicallyOptimisedTransfer.Text
		lblOutliers.Text = txtOutliers.Text
		lblSurgicalBedsOpen.Text = txtSurgicalBedsOpen.Text
		lblElectiveCancellations.Text = txtElectiveCancellations.Text
		lblStaffingIssues.Text = txtStaffingIssues.Text
		lblInfectionControlIssues.Text = txtInfectionControlIssues.Text
		lblAnyOtherIssues.Text = txtAnyOtherIssues.Text
		lblSurgeBedsLocation.Text = txtSurgeBedsLocation.Text
		lblOutlierBedsLocation.Text = txtOutlierBedsLocation.Text
		
		'Surgical confirm lables
		lblPredictionsAdmissionsSurgical.Text = txtPredictionsAdmissionsSurgical.Text
		lblOvernightersInAESurgical.Text = txtOvernightersInAESurgical.Text
		lblCalcDaySurgical.Text = CInt(txtPredictionsAdmissionsSurgical.Text) + CInt(txtOvernightersInAESurgical.Text)
		lblAdmissionsSinceMidnightSurgical.Text = txtAdmissionsSinceMidnightSurgical.Text
		lblCalcAdmOutSurgical.Text = (CInt(txtPredictionsAdmissionsSurgical.Text) + CInt(txtOvernightersInAESurgical.Text)) - CInt(txtAdmissionsSinceMidnightSurgical.Text)
		lblUnplacedInAESurgical.Text = txtUnplacedInAESurgical.Text  
		lblAmbicarePatientNeedingBedSurgical.Text = txtAmbicarePatientNeedingBedSurgical.Text 
		lblGPExpectedOutstandingSurgical.Text = txtGPExpectedOutstandingSurgical.Text  
		lblElectivesStillToBeAllocatedBedSurgical.Text = txtElectivesStillToBeAllocatedBedSurgical.Text  
		lblPlannedITUWardTransfersSurgical.Text = txtPlannedITUWardTransfersSurgical.Text 
		lblOfferedRepatsSurgical.Text = txtOfferedRepatsSurgical.Text 
		lblConversionSurgical.Text = txtConversionSurgical.Text
		lblCalcDemandSurgical.Text = CInt(txtUnplacedInAESurgical.Text) + CInt(txtAmbicarePatientNeedingBedSurgical.Text) + CInt(txtGPExpectedOutstandingSurgical.Text) + CInt(txtElectivesStillToBeAllocatedBedSurgical.Text) + CInt(txtPlannedITUWardTransfersSurgical.Text) + CInt(txtOfferedRepatsSurgical.Text) + CInt(txtConversionSurgical.Text)
		lblCurrentEmptyBedsSurgical.Text = txtCurrentEmptyBedsSurgical.Text 
		lblConfirmedDischargesSurgical.Text = txtConfirmedDischargesSurgical.Text 
		lblQueryDischargesSurgical.Text = txtQueryDischargesSurgical.Text  
		lblCalcAvailabilitySurgical.Text = CInt(txtCurrentEmptyBedsSurgical.text) + CInt(txtConfirmedDischargesSurgical.text) + CInt(txtQueryDischargesSurgical.text)
		lblPreCalcBPSurgical.Text = (CInt(txtCurrentEmptyBedsSurgical.text) + CInt(txtConfirmedDischargesSurgical.text) + CInt(txtQueryDischargesSurgical.text)) 	- ((CInt(txtPredictionsAdmissionsSurgical.text) + CInt(txtOvernightersInAESurgical.text)) - 	CInt(txtAdmissionsSinceMidnightSurgical.text)) - CInt(txtAmbicarePatientNeedingBedSurgical.text) - CInt(txtElectivesStillToBeAllocatedBedSurgical.text)
		lblPreCalcBPDNHSurgical.Text = ((CInt(txtCurrentEmptyBedsSurgical.text) + CInt(txtConfirmedDischargesSurgical.text) + CInt(txtQueryDischargesSurgical.text)) 	- ((CInt(txtPredictionsAdmissionsSurgical.text) + CInt(txtOvernightersInAESurgical.text)) - 	CInt(txtAdmissionsSinceMidnightSurgical.text)) - CInt(txtAmbicarePatientNeedingBedSurgical.text) - CInt(txtElectivesStillToBeAllocatedBedSurgical.text)) - CInt(txtQueryDischargesSurgical.text)
		lblPreCalcBASurgical.Text = (CInt(txtCurrentEmptyBedsSurgical.text) + CInt(txtConfirmedDischargesSurgical.text) + CInt(txtQueryDischargesSurgical.text)) - (CInt(txtUnplacedInAESurgical.text) + CInt(txtAmbicarePatientNeedingBedSurgical.text) + CInt(txtGPExpectedOutstandingSurgical.text) + CInt(txtElectivesStillToBeAllocatedBedSurgical.text) + CInt(txtPlannedITUWardTransfersSurgical.text) + CInt(txtOfferedRepatsSurgical.text) + CInt(txtConversionSurgical.text))
		lblPreCalcBADNHSurgical.Text = ((CInt(txtCurrentEmptyBedsSurgical.text) + CInt(txtConfirmedDischargesSurgical.text) + CInt(txtQueryDischargesSurgical.text)) - (CInt(txtUnplacedInAESurgical.text) + CInt(txtAmbicarePatientNeedingBedSurgical.text) + CInt(txtGPExpectedOutstandingSurgical.text) + CInt(txtElectivesStillToBeAllocatedBedSurgical.text) + CInt(txtPlannedITUWardTransfersSurgical.text) + CInt(txtOfferedRepatsSurgical.text) + CInt(txtConversionSurgical.text))) - CInt(txtQueryDischargesSurgical.text)

		'Medical confirm labels
		lblPredictionsAdmissionsMedical.Text = txtPredictionsAdmissionsMedical.Text
		lblOvernightersInAEMedical.Text = txtOvernightersInAEMedical.Text
		lblCalcDayMedical.Text = CInt(txtPredictionsAdmissionsMedical.Text) + CInt(txtOvernightersInAEMedical.Text)
		lblAdmissionsSinceMidnightMedical.Text = txtAdmissionsSinceMidnightMedical.Text
		lblCalcAdmOutMedical.Text = (CInt(txtPredictionsAdmissionsMedical.Text) + CInt(txtOvernightersInAEMedical.Text)) - CInt(txtAdmissionsSinceMidnightMedical.Text)
		lblUnplacedInAEMedical.Text = txtUnplacedInAEMedical.Text 
		lblAmbicarePatientNeedingBedMedical.Text = txtAmbicarePatientNeedingBedMedical.Text 
		lblGPExpectedOutstandingMedical.Text = txtGPExpectedOutstandingMedical.Text  
		lblElectivesStillToBeAllocatedBedMedical.Text = txtElectivesStillToBeAllocatedBedMedical.Text 
		lblPlannedITUWardTransfersMedical.Text = txtPlannedITUWardTransfersMedical.Text 
		lblOfferedRepatsMedical.Text = txtOfferedRepatsMedical.Text 
		lblConversionMedical.Text = txtConversionMedical.Text
		lblCalcDemandMedical.Text = CInt(txtUnplacedInAEMedical.Text) + CInt(txtAmbicarePatientNeedingBedMedical.Text) + CInt(txtGPExpectedOutstandingMedical.Text) + CInt(txtElectivesStillToBeAllocatedBedMedical.Text) + CInt(txtPlannedITUWardTransfersMedical.Text) + CInt(txtOfferedRepatsMedical.Text) + CInt(txtConversionMedical.Text)
		lblCurrentEmptyBedsMedical.Text = txtCurrentEmptyBedsMedical.Text 
		lblConfirmedDischargesMedical.Text = txtConfirmedDischargesMedical.Text 
		lblQueryDischargesMedical.Text = txtQueryDischargesMedical.Text  
		lblCalcAvailabilityMedical.Text = CInt(txtCurrentEmptyBedsMedical.text) + CInt(txtConfirmedDischargesMedical.text) + CInt(txtQueryDischargesMedical.text)
		lblPreCalcBPMedical.Text = (CInt(txtCurrentEmptyBedsMedical.text) + CInt(txtConfirmedDischargesMedical.text) + CInt(txtQueryDischargesMedical.text)) 	- ((CInt(txtPredictionsAdmissionsMedical.text) + CInt(txtOvernightersInAEMedical.text)) - 	CInt(txtAdmissionsSinceMidnightMedical.text)) - CInt(txtAmbicarePatientNeedingBedMedical.text) - CInt(txtElectivesStillToBeAllocatedBedMedical.text)
		lblPreCalcBPDNHMedical.Text = ((CInt(txtCurrentEmptyBedsMedical.text) + CInt(txtConfirmedDischargesMedical.text) + CInt(txtQueryDischargesMedical.text)) 	- ((CInt(txtPredictionsAdmissionsMedical.text) + CInt(txtOvernightersInAEMedical.text)) - 	CInt(txtAdmissionsSinceMidnightMedical.text)) - CInt(txtAmbicarePatientNeedingBedMedical.text) - CInt(txtElectivesStillToBeAllocatedBedMedical.text)) - CInt(txtQueryDischargesMedical.text)
		lblPreCalcBAMedical.Text = (CInt(txtCurrentEmptyBedsMedical.text) + CInt(txtConfirmedDischargesMedical.text) + CInt(txtQueryDischargesMedical.text)) - (CInt(txtUnplacedInAEMedical.text) + CInt(txtAmbicarePatientNeedingBedMedical.text) + CInt(txtGPExpectedOutstandingMedical.text) + CInt(txtElectivesStillToBeAllocatedBedMedical.text) + CInt(txtPlannedITUWardTransfersMedical.text) + CInt(txtOfferedRepatsMedical.text) + CInt(txtConversionMedical.text))
		lblPreCalcBADNHMedical.Text = ((CInt(txtCurrentEmptyBedsMedical.text) + CInt(txtConfirmedDischargesMedical.text) + CInt(txtQueryDischargesMedical.text)) - (CInt(txtUnplacedInAEMedical.text) + CInt(txtAmbicarePatientNeedingBedMedical.text) + CInt(txtGPExpectedOutstandingMedical.text) + CInt(txtElectivesStillToBeAllocatedBedMedical.text) + CInt(txtPlannedITUWardTransfersMedical.text) + CInt(txtOfferedRepatsMedical.text) + CInt(txtConversionMedical.text))) - CInt(txtQueryDischargesMedical.text)
		
		'Repats confirm labels
		Dim tIn As DataTable = DirectCast(Session("SdtPatIn"), DataTable) 
		Session("dtIn") = tIn
		subRePatsIn.DataSource = tIn
		subRePatsIn.DataBind()
		Dim tOut As DataTable = DirectCast(Session("SdtPatOut"), DataTable) 
		Session("dtOut") = tOut
		subRePatsOut.DataSource = tOut
		subRePatsOut.DataBind()
	End Sub

	Protected Sub confirmSubmitCancel()
		'As the confirmation of the submission is cancelled, display the DIV that has the textboxes for the user to change if they wany
		sitConfirm.Style.Add("display","none")
		infoParagraph.Style.Add("display","block")
		sitMain.Style.Add("display","block")
	End Sub

	' Create datatable to hold repats prior to insert
	Protected Sub buildRepats()
		Dim dtPatIn As New DataTable
		dtPatIn.Columns.Add("ID", GetType(Integer))
		dtPatIn.Columns.Add("RP_Type", GetType(String))
		dtPatIn.Columns.Add("RP_Value", GetType(String))
        Session("SdtPatIn") = dtPatIn 
		Dim dtPatOut As New DataTable
		dtPatOut.Columns.Add("ID", GetType(Integer))
		dtPatOut.Columns.Add("RP_Type", GetType(String))
		dtPatOut.Columns.Add("RP_Value", GetType(String))
        Session("SdtPatOut") = dtPatOut 
		Session("sRID") = rowID 
	End Sub
	
	' Adding repats value to relevant DataTable
	Protected Sub addRepats()
		Session("sRID") = Session("sRID")+1
		if rbllRepatsType.SelectedItem.value = "IN" Then
			Dim tIn As DataTable = DirectCast(Session("SdtPatIn"), DataTable) 
			Dim rowIn As DataRow = tIn.NewRow() 
			rowIn("ID") = Session("sRID")
			rowIn("RP_Type") = rbllRepatsType.SelectedItem.value
			rowIn("RP_Value") = txtRepatsValue.text 
			tIn.Rows.Add(rowIn) 
			Session("dtIn") = tIn
			rePatsIn.DataSource = tIn
			rePatsIn.DataBind()
		else
			Dim tOut As DataTable = DirectCast(Session("SdtPatOut"), DataTable) 
			Dim rowOut As DataRow = tOut.NewRow() 
			rowOut("ID") = Session("sRID")
			rowOut("RP_Type") = rbllRepatsType.SelectedItem.value
			rowOut("RP_Value") = txtRepatsValue.text 
			tOut.Rows.Add(rowOut) 
			Session("dtOut") = tOut
			rePatsOut.DataSource = tOut
			rePatsOut.DataBind()
		End if
		txtRepatsValue.text = ""
		REFocus()
	End Sub
	
	' Remove repats value from IN DataTable
	Protected Sub DelRPin(sender As Object, e As EventArgs)
        DelID = (CType(sender, LinkButton).CommandArgument).ToString
		Dim tIn As DataTable = DirectCast(Session("SdtPatIn"), DataTable) 
		For Each row As DataRow In tIn.Select()
			If row("ID") = DelID Then
				row.Delete()
				Session("dtIn") = tIn
				rePatsIn.DataSource = tIn
				rePatsIn.DataBind()
			End If
		Next
		REFocus()
	End Sub
	
	' Remove repats value from OUT DataTable
	Protected Sub DelRPout(sender As Object, e As EventArgs)
        DelID = (CType(sender, LinkButton).CommandArgument).ToString
		Dim tOut As DataTable = DirectCast(Session("SdtPatOut"), DataTable) 
		For Each row As DataRow In tOut.Select()
			If row("ID") = DelID Then
				row.Delete()
				Session("dtOut") = tOut
				rePatsOut.DataSource = tOut
				rePatsOut.DataBind()
			End If
		Next
		REFocus()
	End Sub
	
	Protected Sub REFocus()
		txtStaffingIssues.Focus()
	End Sub
	
End Class
