local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetRange(0xff)	
	e7:SetProperty(EFFECT_FLAG_REPEAT)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_HAND)
	e7:SetCondition(s.tdcon)
	e7:SetOperation(s.tdop)
	c:RegisterEffect(e7)
end
s.roll_dice=true
s.listed_names={258626,258627,258628,258629}
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.filter(c)
	return c:IsType(TYPE_FIELD) and c:IsSetCard(0x1010)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetOwner()
	Duel.DisableShuffleCheck()
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REMOVED,0,1,nil,id) then
		Duel.SendtoDeck(c,nil,-2,REASON_COST)
		end
			if c then
				local c=e:GetHandler()
				Duel.SendtoDeck(c,nil,-2,REASON_RULE)
			end
				if c then
					local dice=Duel.TossDice(tp,1)
						if dice==1 then
							local tc1=Duel.CreateToken(1-tp,258626)
							local tc2=Duel.CreateToken(tp,258626)
								if tc1 then
									local fc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,10)
										if fc1 then
											Duel.SendtoGrave(fc1,REASON_RULE)
											Duel.BreakEffect()
										end
										Duel.MoveToField(tc1,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
										fc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,10)
								end
								if tc2 then
									local fc2=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
										if fc2 then
											Duel.SendtoGrave(fc2,REASON_RULE)
											Duel.BreakEffect()
										end
										Duel.MoveToField(tc2,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
										fc2=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
								end	 
						elseif dice==2 then
							local tc1=Duel.CreateToken(1-tp,258627)
							local tc2=Duel.CreateToken(tp,258627)
								if tc1 then
									local fc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,10)
										if fc1 then
											Duel.SendtoGrave(fc1,REASON_RULE)
											Duel.BreakEffect()
										end
										Duel.MoveToField(tc1,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
										fc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,10)
										tc1:SetStatus(STATUS_ACTIVATED,true)
								end
								if tc2 then
									local fc2=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
										if fc2 then
											Duel.SendtoGrave(fc2,REASON_RULE)
											Duel.BreakEffect()
										end
										Duel.MoveToField(tc2,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
										fc2=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
								end	 
						elseif dice==3 then
							local tc1=Duel.CreateToken(1-tp,258628)
							local tc2=Duel.CreateToken(tp,258628)
								if tc1 then
									local fc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,10)
										if fc1 then
											Duel.SendtoGrave(fc1,REASON_RULE)
											Duel.BreakEffect()
										end
								Duel.MoveToField(tc1,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
								fc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,10)
								end
								if tc2 then
									local fc2=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
										if fc2 then
											Duel.SendtoGrave(fc2,REASON_RULE)
											Duel.BreakEffect()
										end
										Duel.MoveToField(tc2,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
										fc2=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	 end
	 else
		local tc1=Duel.CreateToken(1-tp,258629)
		local tc2=Duel.CreateToken(tp,258629)
	if tc1 then
		local fc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,10)
		if fc1 then
			Duel.SendtoGrave(fc1,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc1,1-tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
		fc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,10)
	 end
	if tc2 then
		local fc2=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc2 then
			Duel.SendtoGrave(fc2,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc2,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		fc2=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	 end 
	end
	end
end