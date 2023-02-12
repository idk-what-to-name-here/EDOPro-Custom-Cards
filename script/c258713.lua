--Galaxy Journey
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
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.discon)
	e2:SetOperation(s.disop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(s.discon2)
	e3:SetOperation(s.disop2)
	Duel.RegisterEffect(e3,tp)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	e:SetLabelObject(tc)
	return tg and tg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) and not tg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
end
function s.hahafilter(c,rtype)
	return c:IsType(rtype)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		local haha=tg:GetCount()
		local tc=tg:GetFirst()
		local p=tc:GetControler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local rtype=(tc:GetType()&0x7)
		local g=Duel.SelectMatchingCard(tp,s.hahafilter,p,LOCATION_GRAVE,0,haha,haha,nil,rtype)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.ChangeTargetCard(ev,g)
		end
end
function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	return tg and tg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and not tg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD)
end
function s.disop2(e,tp,eg,ep,ev,re,r,rp)
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		local haha=tg:GetCount()
		local tc=tg:GetFirst()
		local p=tc:GetControler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local rtype=(tc:GetType()&0x7)
		local g=Duel.SelectMatchingCard(tp,s.hahafilter,p,LOCATION_ONFIELD,0,haha,haha,nil,rtype)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.ChangeTargetCard(ev,g)
		end
end