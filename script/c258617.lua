local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x577)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),5,5,s.lcheck)
	c:EnableReviveLimit()
	--activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(s.postg2)
	e4:SetOperation(s.posop2)
	c:RegisterEffect(e4)
	--go give the control to mainbody
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.tetg)
	e2:SetOperation(s.teop)
	c:RegisterEffect(e2)
end
s.listed_names={258614}
function s.lcheck(g,lc,sumtype,tp)
	return g:CheckDifferentPropertyBinary(Card.GetAttribute,lc,sumtype,tp)
end
function s.postg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()+e:GetHandler():GetLinkedGroup())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function s.posop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()+e:GetHandler():GetLinkedGroup())
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function s.dragrid_filter(c,e,tp)
	return c:IsCode(258614) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0
end
function s.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not e:GetHandler():IsForbidden() end
end
function s.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
				if c:IsLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(s.dragrid_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
			local tg=Duel.GetFirstMatchingCard(s.dragrid_filter,tp,LOCATION_EXTRA,0,nil,e,tp)
			if tg then
				Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	        end
	    end
	end
end