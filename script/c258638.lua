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
function s.jolynefilter(c)
	return c:IsCode(258637) and c:IsFaceup()
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsExistingTarget(s.jolynefilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.jolynefilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) or not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		--heavy punch
	    local e1=Effect.CreateEffect(c)
	    e1:SetDescription(aux.Stringid(id,0))
    	e1:SetType(EFFECT_TYPE_IGNITION)
    	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	    e1:SetRange(LOCATION_SZONE)
    	e1:SetCountLimit(1)
    	e1:SetCost(s.cost4)
    	e1:SetOperation(s.operation2)
	    c:RegisterEffect(e1)
	    --String Catch
       	local e2=Effect.CreateEffect(c)
	    e2:SetDescription(aux.Stringid(id,2))
    	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
        e2:SetType(EFFECT_TYPE_IGNITION)
    	e2:SetRange(LOCATION_SZONE)
    	e2:SetCountLimit(1)
    	e2:SetTarget(s.seqtg)
    	e2:SetOperation(s.seqop)
    	c:RegisterEffect(e2)
		--Equip limit
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(s.eqlimit)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetLabelObject(tc)
		c:RegisterEffect(e3)
	else
		c:CancelToGrave(false)
	end
		--String Bound
       	local e4=Effect.CreateEffect(c)
       	e4:SetDescription(aux.Stringid(id,1))
	    e4:SetCategory(CATEGORY_CONTROL)
    	e4:SetType(EFFECT_TYPE_IGNITION)
    	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	    e4:SetRange(LOCATION_SZONE)
    	e4:SetCountLimit(1)
    	e4:SetCost(s.cost4)
    	e4:SetTarget(s.target4)
    	e4:SetOperation(s.operation4)
	    c:RegisterEffect(e4)
     	--String Web
    	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_IGNITION)
		e5:SetRange(LOCATION_SZONE)
		e5:SetTarget(s.target)
		e5:SetCost(s.cost4)
		e5:SetCountLimit(1)
		c:RegisterEffect(e5)
	--return to hand
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_MOVE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(s.thcon)
	e6:SetTarget(s.thtg)
	e6:SetOperation(s.thop)
	c:RegisterEffect(e6)
	e6:SetLabelObject(e5)
end
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingTarget(Card.CheckAdjacent,tp,LOCATION_MZONE,0,1,nil) 
	local b2=Duel.IsExistingTarget(Card.CheckAdjacent,tp,0,LOCATION_MZONE,1,nil) 
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,4)},
		{b2,aux.Stringid(id,5)})
	e:SetLabel(op)
	if op==1 then
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local g=Duel.SelectTarget(tp,Card.CheckAdjacent,tp,LOCATION_MZONE,0,1,1,nil)
	else
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local g=Duel.SelectTarget(tp,Card.CheckAdjacent,tp,0,LOCATION_MZONE,1,1,nil)
	end
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	tc:MoveAdjacent()
end
function s.eqlimit(e,c)
	return c:GetControler()==e:GetOwnerPlayer() and c==e:GetLabelObject()
end
function s.specialcostfilter1(c)
	return c:IsCode(258632) and c:IsAbleToGraveAsCost()
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+EVENT_PHASE+PHASE_END,0,1)
	end
	local ec=c:GetEquipTarget()
	if not ec then return end
		ec:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,1)
		e1:SetCondition(s.actcon)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e1)
		c:RegisterFlagEffect(id,RESET_EVENT+RESET_SELF_TURN+RESET_PHASE+PHASE_END,0,1)
        --Gain attack
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ec:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
	    e3:SetDescription(3206)
    	e3:SetType(EFFECT_TYPE_SINGLE)
	    e3:SetCode(EFFECT_CANNOT_ATTACK)
    	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
    	e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
     	ec:RegisterEffect(e3)
		if ec:IsImmuneToEffect(e1) or ec:IsImmuneToEffect(e2) or ec:IsImmuneToEffect(e3) then return end
		local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
		if #g==0 or ((ec:IsHasEffect(EFFECT_DIRECT_ATTACK) or not g:IsExists(aux.NOT(Card.IsHasEffect),1,nil,EFFECT_IGNORE_BATTLE_TARGET)) and Duel.SelectYesNo(tp,31)) then
			Duel.CalculateDamage(ec,nil)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
			Duel.CalculateDamage(ec,g:Select(tp,1,1,nil):GetFirst())
		end
		if ec then
        --a
       	local e4=Effect.CreateEffect(c)
    	e4:SetCategory(CATEGORY_TOHAND)
    	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    	e4:SetCode(EVENT_PHASE+PHASE_END)
    	e4:SetRange(LOCATION_SZONE)
    	e4:SetTarget(s.target5)
    	e4:SetOperation(s.operation5)
    	c:RegisterEffect(e4)
		end
	end
function s.actcon(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and c:GetBattleTarget()~=nil
		and e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function s.specialcostfilter2(c)
	return c:IsCode(258632) and c:IsAbleToGraveAsCost()
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.specialcostfilter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,s.specialcostfilter1,1,1,REASON_COST+REASON_DISCARD)
end
function s.filter(c,e)
	return c:IsFaceup()
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,g,1,0,0)
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
	end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local c=e:GetHandler()
		--Cannot attack this turn
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3206)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		tc:RegisterEffect(e1)		
		c:RegisterFlagEffect(id,RESET_EVENT+RESET_SELF_TURN+RESET_PHASE+PHASE_END,0,1)
		--Cannot activate its effect
		local e2=e1:Clone()
		e2:SetDescription(3302)
		e2:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e2)
        end
		if tc then
		local e3=Effect.CreateEffect(c)
    	e3:SetCategory(CATEGORY_TOHAND)
    	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    	e3:SetCode(EVENT_PHASE+PHASE_END)
    	e3:SetRange(LOCATION_SZONE)
    	e3:SetTarget(s.target5)
    	e3:SetOperation(s.operation5)
    	c:RegisterEffect(e3)
		end
end
function s.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id)~=0 end
	e:GetHandler():ResetFlagEffect(id)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end
function s.thfilter(c)
	return c:IsCode(258632) and c:IsAbleToHand()
end
function s.operation5(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	--destroy
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.descon)
	e1:SetOperation(s.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	c:RegisterEffect(e1)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,nil,LOCATION_REASON_COUNT)+Duel.GetLocationCount(tp,LOCATION_MZONE,nil,LOCATION_REASON_COUNT)>0 end
	local zone=Duel.SelectFieldZone(tp,3,LOCATION_MZONE,LOCATION_MZONE,0,true)
	Duel.Hint(HINT_ZONE,tp,zone)
	e:SetLabel(zone)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			end
	end
end
function s.zonefilter(c,tp,zone)
	return c:IsFaceup() and aux.IsZone(c,zone,tp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabelObject():GetLabel()
	return eg:IsExists(s.zonefilter,1,nil,tp,zone)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local zone=e:GetLabelObject():GetLabel()
	local g=eg:Filter(s.zonefilter,nil,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=e:GetLabelObject():GetLabel()
	local g=eg:Filter(s.zonefilter,nil,tp,zone)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end