--Zero Gravitation
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ag,da=eg:GetFirst():GetAttackableTarget()
		local at=Duel.GetAttackTarget()
		return ag:IsExists(aux.TRUE,1,nil) or (at~=nil and da)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ag,da=eg:GetFirst():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	if da and at~=nil then
		local sel=0
		Duel.Hint(HINT_SELECTMSG,tp,31)
		if ag:IsExists(aux.TRUE,1,nil) then
			sel=Duel.SelectOption(tp,1213,1214)
		else
			sel=Duel.SelectOption(tp,1213)
		end
		if sel==0 then
			Duel.ChangeAttackTarget(nil)
			return
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
	local g=ag:Select(tp,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ChangeAttackTarget(tc)
	end
	local udeck=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil)
	local opdeck=Duel.GetMatchingGroup(aux.TRUE,1-tp,LOCATION_DECK,0,nil)
		if #udeck>0 then 
			local udeckcards=Duel.CreateToken(tp,udeck)
		end
		if #opdeck>0 then
			local opdeckcards=Duel.CreateToken(1-tp,opdeck)
		end
		if opdeckcards:IsAbleToHand() then
			Duel.SendtoDeck(opdeckcards,tp,0,REASON_EFFECT)
			opdeckcards:CompleteProcedure()
		end
		if udeckcards:IsAbleToHand() then
			Duel.SendtoDeck(udeckcards,1-tp,0,REASON_EFFECT)
			udeckcards:CompleteProcedure()
		end
end