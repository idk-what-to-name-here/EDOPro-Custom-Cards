local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetRange(0xff)
	e1:SetOperation(s.stop)
	Duel.RegisterEffect(e1,0)
	--cannot lose because of deckout
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_LOSE_DECK)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTargetRange(1,0)
	e2:SetValue(1)
	c:RegisterEffect(e2)
    --you dont lose lp
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetTargetRange(1,1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
    --Take damage nerd
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end
s.listed_names={258624}
function s.filter(c)
	return c:IsCode(258624) and c:IsAbleToHand()
end
function s.stop(e)
	local c=e:GetHandler()
	local tp=c:GetOwner()
	Duel.DisableShuffleCheck()
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REMOVED,0,1,nil,id) then
		Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	else
		local hct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
		Duel.Hint(HINT_CARD,0,id)
		local g=Duel.GetMatchingGroup(aux.NOT(Card.IsSetCard),tp,0xff,0,c,0)
		if #g>0 then
			Duel.SendtoDeck(g,nil,-2,REASON_RULE)
		end
        if hct then
	local code=258624
	local tc=Duel.CreateToken(tp,code)
	if tc:IsAbleToHand() and Duel.GetTurnPlayer()==tp then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		tc:CompleteProcedure()
	end
		end
	end
end
function s.damfilter(c,tp)
	return c:IsMonster() and c:IsPreviousLocation(LOCATION_MZONE) and c:IsLocation(LOCATION_GRAVE) 
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:GetOwner()==tp
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=eg:FilterCount(s.damfilter,nil,tp)
	local ct2=eg:FilterCount(s.damfilter,nil,1-tp)
	Duel.Damage(tp,ct1*1,REASON_EFFECT)
	Duel.Damage(1-tp,ct2*1,REASON_EFFECT)
end