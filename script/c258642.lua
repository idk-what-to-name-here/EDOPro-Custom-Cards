local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(aux.RemainFieldCost)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
end
function s.userfilter(c)
	return c:IsCode(258641) and c:IsFaceup()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsExistingTarget(s.userfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.userfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) or not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		--Bomb Check
       	local e1=Effect.CreateEffect(c)
	    e1:SetDescription(aux.Stringid(id,0))
    	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
        e1:SetType(EFFECT_TYPE_IGNITION)
    	e1:SetRange(LOCATION_SZONE)
    	e1:SetCountLimit(1)
    	e1:SetOperation(s.seqop)
    	c:RegisterEffect(e1,true)
    	--First Bomb
        local e2=Effect.CreateEffect(c)
	    e2:SetDescription(aux.Stringid(id,1))
    	e2:SetCategory(CATEGORY_CONTROL)
    	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
        e2:SetType(EFFECT_TYPE_IGNITION)
    	e2:SetRange(LOCATION_SZONE)
	    e2:SetCountLimit(1)
    	e2:SetCondition(s.normalcon)
        e2:SetCost(s.cost1)
    	e2:SetTarget(s.seqtg)
		e2:SetOperation(s.seqop2)
        c:RegisterEffect(e2)
      	--Second Bomb
        local e3=Effect.CreateEffect(c)
	    e3:SetDescription(aux.Stringid(id,2))
    	e3:SetCategory(CATEGORY_CONTROL)
        e3:SetType(EFFECT_TYPE_IGNITION)
    	e3:SetRange(LOCATION_SZONE)
	    e3:SetCountLimit(1)
        e3:SetCost(s.cost1)
    	e3:SetTarget(s.seqtg3)
		e3:SetOperation(s.seqop3)
        c:RegisterEffect(e3)
		--Equip limit
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_EQUIP_LIMIT)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetValue(s.eqlimit)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetLabelObject(tc)
		c:RegisterEffect(e4)
	else
		c:CancelToGrave(false)
		end
end
s.listed_names={89907228}
function s.switchcon(e)
	local personbomb,zone=e:GetLabelObject():GetLabel()
	return eg:IsExists(s.zonefilter,1,nil,tp,zone) and eg:IsExists(s.personbombfilter,1,nil,tp,personbomb)
end
function s.heavycon(e)
  return e:GetHandler():GetFlagEffect(id)>0
end
function s.normalcon(e)
  return e:GetHandler():GetFlagEffect(id)==0
end
function s.eqlimit(e,c)
	return c:GetControler()==e:GetOwnerPlayer() and c==e:GetLabelObject()
end
function s.filter2(c)
	return c:IsCode(258642) and c:IsFaceup()
end
function s.specialcostfilter1(c)
	return c:IsCode(258632) and c:IsAbleToGraveAsCost()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.specialcostfilter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,s.specialcostfilter1,1,1,REASON_COST+REASON_DISCARD)
end
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.GetLocationCount(1-tp,LOCATION_MZONE,nil,LOCATION_REASON_COUNT)+Duel.GetLocationCount(tp,LOCATION_MZONE,nil,LOCATION_REASON_COUNT)>0
	local b2=Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,4)},
		{b2,aux.Stringid(id,5)})
	e:SetLabel(op)
	if op==1 then
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
    local zone=Duel.SelectFieldZone(tp,1,0,LOCATION_MZONE,0,true)
	Duel.Hint(HINT_ZONE,tp,zone)
	e:SetLabel(zone)
	else
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local personbomb=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,personbomb,1,0,0)
		e:SetLabelObject(dt)
		end
end
function s.seqop2(e,tp,eg,ep,ev,re,r,rp)
      local c=e:GetHandler()
	op=e:GetLabel()
	if op==2 then
    	local tc=Duel.GetFirstTarget()
				tc1:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		    if tc:IsRelateToEffect(e) then
		    --Bomb Check
          	local e1=Effect.CreateEffect(c)
	        e1:SetDescription(aux.Stringid(id,0))
            e1:SetType(EFFECT_TYPE_IGNITION)
        	e1:SetRange(LOCATION_SZONE)
        	e1:SetCountLimit(1)
			e1:SetCondition(s.detonatecon)
			e1:SetTarget(s.detonatetg)
        	e1:SetOperation(s.detonateop)
        	c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e1:SetLabelObject(dt)
			tc:RegisterEffect(e1)
			end
	end
end
function s.detonatecon(e)
	local dt=e:GetLabelObject()
	if not dt:IsExists(s.desfilter,1,nil) then
		dt:DeleteGroup()
		e:Reset()
		return false
	end
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel()
end
function s.detonatefilter(c)
	return c:GetFlagEffect(id)>0
end
function s.detonatetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	   local dt=e:GetLabelObject()
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dt,1,0,0)
end
function s.detonateop(e,tp,eg,ep,ev,re,r,rp)
	local dt=e:GetLabelObject()
	local tg=dt:Filter(s.desfilter,nil)
	dt:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
function s.zonefilter(c,tp,zone)
	return c:IsFaceup() and aux.IsZone(c,zone,tp)
end
function s.personbombfilter(c,tp,personbomb)
	return c:IsFaceup() and c:IsRelateToEffect(personbomb)
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp)
      local c=e:GetHandler()
	     if c:GetFlagEffect(id)>0 then
		     c:ResetFlagEffect(id)
	     else
		 e:GetHandler():RegisterEffect(id,RESET_EVENT+RESETS_STANDARD+PHASE_END+RESET_SELF_TURN,0,0)
		 end
end
function s.seqtg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,1500,1500,0,0,0,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.seqop3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,1500,1500,0,0,0,POS_FACEUP) then
		local token=Duel.CreateToken(tp,id+1)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetTarget(s.lookoverheretg)
			e1:SetOperation(s.boomop)
			token:RegisterEffect(e1,true)
				Duel.SpecialSummonComplete()
	end
end
function s.lookoverheretg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
		local g,atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMaxGroup(Card.GetCounter(atk,0x1116))
end
function s.boomop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g,atk=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMaxGroup(Card.GetCounter(atk,0x1116))
	mtg=atk:GetMaxGroup(Card.GetCounter(g,0x1116))
	sg=mtg:GetFirst()
    	local seq=sg:GetSequence(mtg)
         mt=seq:CheckAdjacent(seq)
		 if mt then
		  Duel.MoveSequence(c,mt)
		 end
end