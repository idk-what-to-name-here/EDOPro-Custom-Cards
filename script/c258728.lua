--Gimmick Vengeance
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(id)
	e1:SetCondition(s.damcon)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		--register
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetOperation(s.operation)
		Duel.RegisterEffect(e2,0)
	end)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:GetFlagEffect(id)==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetRange(LOCATION_MZONE)
			e1:SetLabel(tc:GetOverlayCount())
			e1:SetOperation(s.op)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1) 	
		end
		tc=g:GetNext()
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==c:GetOverlayCount() or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,258728) then return end
	local val=0
	if e:GetLabel()>c:GetOverlayCount() then
		val=e:GetLabel()-c:GetOverlayCount()
	else
		val=c:GetOverlayCount()-e:GetLabel()
	end
	Duel.RaiseEvent(c,id,re,REASON_EFFECT,rp,tp,val)
	e:SetLabel(c:GetOverlayCount())
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	local c=e:GetHandler()
	Debug.Message(ev>0 and (not re or not re:GetHandler():IsType(TYPE_XYZ)) and c:GetOverlayTarget()~=nil)
	return ev>0 and (not re or not re:GetHandler():IsType(TYPE_XYZ)) and c:GetOverlayTarget()~=nil
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummon(tp) then
		local token=Duel.CreateToken(tp,511004325)
		local atk=e:GetHandler():GetOverlayTarget():GetAttack()
		local c=e:GetHandler()
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk+100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end