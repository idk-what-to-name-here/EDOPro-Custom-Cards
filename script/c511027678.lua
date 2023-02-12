--ＧＯゴー－ＤディーＤディーＤディー神しん零れい王おうゼロゴッド・レイジ
--Divine Go-D/D/D Zero King Zero God Reiji
local s,id=GetID()
function s.initial_effect(c)
	--Enable pendulum summon
	Pendulum.AddProcedure(c)
	--LP
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.deathcon)
	e1:SetOperation(s.deathop)
	c:RegisterEffect(e1)
	--reduce atk to 0
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.lowercon)
	e2:SetOperation(s.lowerop)
	c:RegisterEffect(e2)
	--do things
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.deathcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function s.deathop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,0)
end
function s.lowercon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	e:SetLabelObject(a)
	local at=Duel.GetAttackTarget()
	return a and a:IsFaceup() and at==c
end
function s.lowerop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetCondition(s.damcon)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.damcon(e)
	local tc=e:GetLabelObject()
	return tc==Duel.GetAttacker()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g,exg=Duel.GetReleaseGroup(tp):Split(aux.ReleaseCostFilter,e:GetHandler(),tp)
	exg:RemoveCard(e:GetHandler())
	e:SetLabel(#g)
	if chk==0 then return #g>0 and Duel.GetMZoneCount(tp,g)>0 end
	Duel.Release(g,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=e:GetLabel()
	if chk==0 then
		local b1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local b2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE+LOCATION_SZONE+LOCATION_HAND+LOCATION_GRAVE,nil)
		return (gc>=1 and b1) or (gc>=3 and b2)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gc=e:GetLabel()
	if gc>=1 then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
				for tc in aux.Next(g) do
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_ATTACK_FINAL)
					e1:SetValue(0)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
	end
	if gc>=3 then
		local g1=Duel.GetOverlayGroup(tp,0,1)
		if #g1>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE+LOCATION_SZONE+LOCATION_HAND+LOCATION_GRAVE,nil)
		if 	Duel.SendtoDeck(g,nil,-2,REASON_EFFECT+REASON_TEMPORARY) then
			local fid=c:GetFieldID()
			local og=Duel.GetOperatedGroup()
			for oc in aux.Next(og) do
				oc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(og)
			e1:SetCondition(s.retcon)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g:IsExists(s.retfilter,1,nil,e:GetLabel()) then
		return true
	else 
		g:DeleteGroup()
		e:Reset()
		return false
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetLabelObject()
	local g=og:Filter(s.retfilter,nil,e:GetLabel())
	og:DeleteGroup()
	if #g<=0 then return end
	local p=g:GetFirst():GetPreviousControler()
	local tg=Group.CreateGroup()
	if g then
		tg:Merge(g)
	end
	for tc in aux.Next(tg) do
		if tc:GetPreviousLocation()==LOCATION_MZONE then
			Duel.ReturnToField(tc)
		elseif tc:IsPreviousLocation(LOCATION_HAND) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		elseif tc:IsPreviousLocation(LOCATION_GRAVE) then
			Duel.SendtoGrave(tc,REASON_EFFECT,p)
		else
			Duel.MoveToField(tc,p,p,tc:GetPreviousLocation(),tc:GetPreviousPosition(),true,(1<<tc:GetPreviousSequence()))
		end
	local letstry=tc:GetPreviousEquipTarget()
		if letstry then
			Debug.PreEquip(tc,letstry)
		end
	end
end