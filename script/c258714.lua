--Tachyon Refresh
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) then
			local c=e:GetHandler()
		local res=Duel.GetTurnPlayer()==1-tp and 4 or 3
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(0)
		e1:SetCondition(s.tccon)
		e1:SetOperation(s.tcop)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,res)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,0))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(1082946)
		e2:SetLabelObject(e1)
		e2:SetOwnerPlayer(tp)
		e2:SetOperation(s.reset)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,res)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetLabelObject(e1)
		e3:SetCondition(s.retcon)
		e3:SetOperation(s.retop)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,res)
		Duel.RegisterEffect(e3,tp)
		Duel.RegisterFlagEffect(0,e1:GetFieldID()+id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() then e:Reset() return end
	s.tcop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function s.retfilter(c)
	return c:GetFlagEffect(id)~=0
end
function s.tccon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabel()==2 and Duel.GetTurnPlayer()~=tp then
		e:Reset()
		return false
	else return Duel.GetTurnPlayer()~=tp and Duel.GetFlagEffect(0,e:GetFieldID()+id)==0 end
end
function s.tcop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()+1
	e:SetLabel(ct)
	e:GetOwner():SetTurnCounter(ct)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() then e:Reset() return false end
	return Duel.GetTurnPlayer()~=tp and e:GetLabelObject():GetLabel()==3
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() then e:Reset() return false end
	local c=e:GetHandler()
	if c:IsSSetable() then
		Duel.SSet(tp,c)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
	end
	if re then re:Reset() end
	e:Reset()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp_cost=Duel.GetLP(tp)-10
	if chk==0 then return lp_cost>0 and Duel.CheckLPCost(tp,lp_cost) end
	e:SetLabel(lp_cost)
	Duel.PayLPCost(tp,lp_cost)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,LOCATION_MZONE)
		local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_MZONE) then
		local atk=g:GetFirst():GetTextAttack()
		if atk<0 then atk=0 end
		local atk=atk+e:GetLabel()
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if c then
		e:SetProperty(e:GetProperty()|EFFECT_FLAG_IGNORE_IMMUNE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetValue(function(e,te) return te:GetOwner()~=e:GetOwner() end)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e3,true)
		Duel.AdjustInstantly(c)
	end
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		local atk=atk+e:GetLabel()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:IsPreviousLocation(LOCATION_MZONE) then
			e:SetProperty(e:GetProperty()&~EFFECT_FLAG_IGNORE_IMMUNE)
			Duel.BreakEffect()
			if Duel.Damage(1-tp,atk,REASON_EFFECT) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(1,0)
				e1:SetValue(aux.TRUE)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
				e2:SetDescription(aux.Stringid(id,2))
				e2:SetReset(RESET_PHASE+PHASE_END)
				e2:SetTargetRange(1,0)
				Duel.RegisterEffect(e2,tp)
				--damage
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_FIELD)
				e4:SetCode(EFFECT_CHANGE_DAMAGE)
				e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH)
				e4:SetReset(RESET_PHASE+PHASE_END)
				e4:SetTargetRange(0,1)
				e4:SetValue(s.value)
				Duel.RegisterEffect(e4,tp)
			end
		end
end
function s.value(e,re,dam,r,rp,rc)
	if (r&REASON_BATTLE)~=0 then
		return dam*2
	else
		return dam
	end
end