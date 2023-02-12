--Memory Oblivion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local g1=Duel.GetOverlayGroup(tp,1,1)
		if #g1>0 then
			Duel.SendtoGrave(g1,REASON_EFFECT)
		end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if 	Duel.SendtoDeck(g,nil,-2,REASON_EFFECT+REASON_TEMPORARY) then
			local fid=c:GetFieldID()
			local og=Duel.GetOperatedGroup()
			for oc in aux.Next(og) do
				oc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_LEAVE_FIELD)
			e1:SetReset(RESET_EVENT+EVENT_LEAVE_FIELD)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(og)
			e1:SetCondition(s.retcon)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
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
		Duel.ReturnToField(tc)
	end
end
